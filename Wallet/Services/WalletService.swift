//
//  WalletService.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import stellarsdk
import Alamofire

struct WalletService {
    
    static let mnemonic = Wallet.generate12WordMnemonic()
    static var keyPair: KeyPair?
    
    static func login(_ passphrase: String, completion: @escaping (Bool) -> Void) {
        generateKeyPair(mnemonic: passphrase, completion: { (keyPair) in
            guard let keyPair = keyPair else {
                completion(false)
                return
            }
            KeychainHelper.publicKey = keyPair.accountId
            KeychainHelper.privateSeed = keyPair.secretSeed
            KeychainHelper.mnemonic = passphrase
            NotificationCenter.default.post(name: Notification.Name("login"), object: nil, userInfo: [:])
            completion(true)
        })
    }
    
    static func signUp(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            let passphrase = Wallet.generate12WordMnemonic()
            KeychainHelper.mnemonic = passphrase
            generateKeyPair(mnemonic: passphrase) { (keyPair) in
                guard let keyPair = keyPair else {
                    return
                }
                let publicKey = keyPair.accountId
                KeychainHelper.publicKey = publicKey
                KeychainHelper.privateSeed = keyPair.secretSeed
                UserService.getUserFor(publicKey: publicKey, completion: { (u) in })
                createStellarTestAccount(accountID: keyPair.accountId, completion: {
                    DispatchQueue.main.async {
                        completion()
                    }
                })
            }
        }
    }
    
    internal static func savePublicKey(_ publicKey: String) {
        let data = ["publicKey":publicKey]
        db.collection("users").document(publicKey).setData(data, merge: true)
    }
    
    static func logOut(completion: @escaping () -> Void) {
        Payment.deleteAll()
        KeychainHelper.publicKey = ""
        KeychainHelper.privateSeed = ""
        CurrentUser.email = ""
        CurrentUser.image = ""
        CurrentUser.username = ""
        CurrentUser.uuid = ""
        CurrentUser.name = ""
        Payment.deleteAll()
        completion()
    }
    
    static func generateKeyPair(mnemonic: String, completion: @escaping (KeyPair?) -> Void) {
        let keyPair = try? Wallet.createKeyPair(mnemonic: mnemonic, passphrase: nil, index: 0)
        completion(keyPair)
    }
    
    static func createStellarTestAccount(accountID: String, completion: @escaping () -> Swift.Void) {
        Stellar.sdk.accounts.createTestAccount(accountId: accountID) { (response) -> (Void) in
            switch response {
            case .success:
                guard let asset = Token.USD.toRawAsset() else { return }
                changeTrust(asset: asset, completion: { (trusted) in
                    print("Trustline set: \(trusted)")
                    completion()
                })
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    
    static func changeTrust(asset: Asset, completion: @escaping (Bool) -> Void) {
        
        guard let sourceKeyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
            completion(false)
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: KeychainHelper.publicKey) { (response) -> (Void) in
            switch response {
            case .success(let accountResponse):
                do {
                    let changeTrustOperation = ChangeTrustOperation(sourceAccount: sourceKeyPair, asset: asset, limit: 10000000000)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [changeTrustOperation],
                                                      memo: nil,
                                                      timeBounds: nil)
                    
                    try transaction.sign(keyPair: sourceKeyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction, response: { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            completion(true)
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion(false)
                        }
                    })
                    
                }
                catch {
                    completion(false)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    
    static func getAssets(completion: @escaping ([Token]) -> Swift.Void) {
        let accountId = KeychainHelper.publicKey
        
        Stellar.sdk.accounts.getAccountDetails(accountId: accountId) { (response) -> (Void) in
            switch response {
            case .success(let accountDetails):
                var tokens: [Token] = []
                accountDetails.balances.forEach({ (asset) in
                    let token = Token(response: asset)
                    let assetCode = token.assetCode ?? ""
                    guard assetCode == "XSG" || token.isNative else { return }
                    tokens.append(token)
                })
                DispatchQueue.main.async {
                    completion(tokens)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    completion([])
                    print("account is setup improperly. It either doesn't trust our native asset, or something else may be wrong.")
                }
            }
        }
    }
    
    
    static func getAccountDetails(completion: @escaping (Token?) -> Swift.Void) {
        let accountId = KeychainHelper.publicKey
        
        Stellar.sdk.accounts.getAccountDetails(accountId: accountId) { (response) -> (Void) in
            switch response {
            case .success(let accountDetails):
                accountDetails.balances.forEach({ (asset) in
                    let token = Token(response: asset)
                    let assetCode = Token.XSG.assetCode ?? "XSG"
                    if token.assetCode == assetCode {
                        DispatchQueue.main.async {
                            completion(token)
                        }
                    }
                })

            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
    
    
    static func fetchPayments(completion: @escaping ([Payment]) -> Swift.Void) {
        let accountId = KeychainHelper.publicKey
        var payments = [Payment]()
        Stellar.sdk.payments.getPayments(forAccount: accountId, from: nil, order: Order.descending, limit: 100) { (response) -> (Void) in
            switch response {
            case .success(let details):
                for record in details.records {
                    if let payment = record as? PaymentOperationResponse {
                        let isReceived = payment.from != KeychainHelper.publicKey ? true : false
                        let payment = Payment.findOrCreatePayment(id: payment.id,
                                                                  assetCode: payment.assetCode ?? "",
                                                                  issuer: payment.assetIssuer ?? "",
                                                                  amount: payment.amount,
                                                                  to: payment.to,
                                                                  from: payment.from,
                                                                  timestamp: record.createdAt,
                                                                  isReceived: isReceived,
                                                                  in: PersistenceService.context)
                        payments.append(payment)
                    }
                }
                DispatchQueue.main.async {
                    completion(payments)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static var streamItem:OperationsStreamItem? = nil
    
    static func streamPayments(completion: @escaping (Payment) -> Swift.Void) {
        let accountID = KeychainHelper.publicKey
        
        streamItem = Stellar.sdk.payments.stream(for: .paymentsForAccount(account: accountID, cursor: nil))
        
        streamItem?.onReceive { (response) -> (Void) in
            switch response {
            case .open:
                break
            case .response(let id, let operationResponse):
                if let paymentResponse = operationResponse as? PaymentOperationResponse {
                    
                    let isReceived = paymentResponse.from != accountID ? true : false
                    
                    let payment = Payment.findOrCreatePayment(id: id,
                                                              assetCode: paymentResponse.assetCode ?? "",
                                                              issuer: paymentResponse.assetIssuer ?? "",
                                                              amount: paymentResponse.amount,
                                                              to: paymentResponse.to,
                                                              from: paymentResponse.from,
                                                              timestamp: paymentResponse.createdAt,
                                                              isReceived: isReceived,
                                                              in: PersistenceService.context)
                    completion(payment)
                    
                }
            case .error(let err):
                print(err?.localizedDescription ?? "Error")
            }
        }
    }
    
    
    static func sendPayment(token: Token, toAccountID: String, amount: Decimal, completion: @escaping (Bool) -> Void) {
        
        guard KeychainHelper.privateSeed != "",
            let sourceKeyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
                DispatchQueue.main.async {
                    print("NO SOURCE KEYPAIR")
                    completion(false)
                }
                return
        }
        
        guard  let destinationKeyPair = try? KeyPair(publicKey: PublicKey.init(accountId: toAccountID), privateKey: nil) else {
            DispatchQueue.main.async {
                completion(false)
            }
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: sourceKeyPair.accountId) { (response) -> (Void) in
            
            switch response {
            case .success(let accountResponse):
                do {
                    let asset = token.toRawAsset()
//                    guard let feeAccount = try? KeyPair(publicKey: PublicKey.init(accountId: feeAddress)) else {
//                        return
//                    }
                    
                    let paymentOperation = PaymentOperation(sourceAccount: sourceKeyPair,
                                                            destination: destinationKeyPair,
                                                            asset: asset ?? Token.XLM.toRawAsset()!,
                                                            amount: amount)
                    
//                    let feeOperation = PaymentOperation(sourceAccount: sourceKeyPair,
//                                                        destination: feeAccount,
//                                                            asset: asset,
//                                                            amount: amount*0.008)
                    
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [paymentOperation],
                                                      memo: nil,
                                                      timeBounds:nil)
                    
                    try transaction.sign(keyPair: sourceKeyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            DispatchQueue.main.async {
                                completion(true)
                                print(response)
                            }
                        case .failure(let error):
                            
                            let xdr = try! transaction.getTransactionHash(network: Stellar.network)
                            print(xdr)
                            
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"Post Payment Error", horizonRequestError:error)
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        print("FAILED TO GET ACCOUNT")
                        completion(false)
                    }
                }
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Post Payment Error", horizonRequestError:error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    
}

