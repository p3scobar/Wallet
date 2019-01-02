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
        let passphrase = Wallet.generate12WordMnemonic()
        KeychainHelper.mnemonic = passphrase
        generateKeyPair(mnemonic: passphrase) { (keyPair) in
            guard let keyPair = keyPair else {
                return
            }
            KeychainHelper.publicKey = keyPair.accountId
            KeychainHelper.privateSeed = keyPair.secretSeed
            createStellarTestAccount(accountID: keyPair.accountId, completion: {
                completion()
            })
        }
    }
    
    static func logOut(completion: @escaping () -> Void) {
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
                let asset = Token.GOLD.toRawAsset()
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
    
    
    static func getAccountDetails(completion: @escaping ([Token]) -> Swift.Void) {
        let accountId = KeychainHelper.publicKey
        Stellar.sdk.accounts.getAccountDetails(accountId: accountId) { (response) -> (Void) in
            switch response {
            case .success(let accountDetails):
                var tokens = [Token]()
                accountDetails.balances.forEach({ (asset) in
                    let token = Token(response: asset)
                    if !token.isNative {
                        tokens.append(token)
                    }
                })
                DispatchQueue.main.async {
                    completion(tokens)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion([])
                }
                print(error.localizedDescription)
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
    
    
    static func fetchTransactions(completion: @escaping ([Payment]) -> Swift.Void) {
        let accountId = KeychainHelper.publicKey
        guard accountId != "" else { return }
        var payments = [Payment]()
        Stellar.sdk.payments.getPayments(forAccount: accountId, from: nil, order: Order.descending, limit: 100) { (response) -> (Void) in
            switch response {
            case .success(let details):
                for record in details.records {
                    if let payment = record as? PaymentOperationResponse {
                        let payment = Payment.findOrCreatePayment(id: payment.id,
                                                                  assetCode: payment.assetCode ?? "",
                                                                  issuer: payment.assetIssuer ?? "",
                                                                  amount: payment.amount,
                                                                  to: payment.to,
                                                                  from: payment.from,
                                                                  timestamp: record.createdAt,
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
    
    
    
//    static func streamPayments(completion: @escaping (Payment) -> Swift.Void) {
//        let accountID = KeychainHelper.publicKey
//        let issuerID = Assets.BNK.issuerAccountID
//        let issuingAccountKeyPair = try? KeyPair(accountId:  issuerID)
//        let BNK = Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "BNK", issuer: issuingAccountKeyPair)
//
//        Stellar.sdk.payments.stream(for: .paymentsForAccount(account: accountID, cursor: "now")).onReceive { (response) -> (Void) in
//            switch response {
//            case .open:
//                break
//            case .response(let id, let operationResponse):
//                if let paymentResponse = operationResponse as? PaymentOperationResponse {
//                    if paymentResponse.assetCode == BNK?.code {
//                        let isReceived = paymentResponse.from != accountID ? true : false
//                        let date = paymentResponse.createdAt
//                        let amount = paymentResponse.amount
//                        let data = ["amount":amount,
//                                    "id":paymentResponse.id,
//                                    "date":date,
//                                    "isReceived":isReceived] as [String : Any]
//                        let payment = Payment.findOrCreatePayment(id: paymentResponse.id, data: data, in: PersistenceService.context)
//                        completion(payment)
//
//                        print("Payment of \(paymentResponse.amount) BNK from \(paymentResponse.sourceAccount) received -  id \(id)" )
//                    }
//                }
//            case .error(let err):
//                print(err!.localizedDescription)
//            }
//        }
//    }
    
    
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
                    
                    let paymentOperation = PaymentOperation(sourceAccount: sourceKeyPair,
                                                            destination: destinationKeyPair,
                                                            asset: asset,
                                                            amount: amount)
                    
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

