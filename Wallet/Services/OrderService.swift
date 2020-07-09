//
//  OrderService.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import stellarsdk

struct OrderService {
    
//    static let publicKey = KeychainHelper.publicKey
//    static let secretKey = KeychainHelper.privateSeed
    
    static func getOrderBook(buy: Token, sell: Token, limit: Int?, completion: @escaping (_ asks: [ExchangeOrder], _ bids: [ExchangeOrder]) -> Void) {
        let sellingAssetType = sell.assetType
        let buyingAssetType = buy.assetType
        let sellingAssetCode = sell.assetCode
        let buyingAssetCode = buy.assetCode
        let sellingAssetIssuer = sell.assetIssuer ?? ""
        let buyingAssetIssuer = buy.assetIssuer ?? ""
        Stellar.sdk.orderbooks.getOrderbook(sellingAssetType: sellingAssetType, sellingAssetCode: sellingAssetCode, sellingAssetIssuer: sellingAssetIssuer, buyingAssetType: buyingAssetType, buyingAssetCode: buyingAssetCode, buyingAssetIssuer: buyingAssetIssuer, limit: limit) { (response) -> (Void) in
            switch response {
            case .success(let orderBook):
                var asks: [ExchangeOrder] = []
                var bids: [ExchangeOrder] = []
                orderBook.asks.forEach({ (ask) in
                    let order = ExchangeOrder(exchangeOrder: ask, side: .sell)
                    asks.append(order)
//                    print("ASK – \(ask.price)")
                })
                orderBook.bids.forEach({ (bid) in
                    let order = ExchangeOrder(exchangeOrder: bid, side: .buy)
                    bids.append(order)

                })
                asks.sort { $0.price > $1.price }
                bids.sort { $0.price > $1.price }
                
                lastPrice = asks.first?.price ?? 0.0
                
                
                DispatchQueue.main.async {
                    completion(asks, bids)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func bestPrices(buy: Token, sell: Token, completion: @escaping (_ bestOffer: Double, _ bestBid: Double) -> Void) {
        let sellingAssetType = sell.assetType
        let buyingAssetType = buy.assetType
        let sellingAssetCode = sell.assetCode ?? ""
        let sellingAssetIssuer = sell.assetIssuer ?? ""
        let buyingAssetCode = buy.assetCode ?? ""
        let buyingAssetIssuer = buy.assetIssuer ?? ""
        Stellar.sdk.orderbooks.getOrderbook(sellingAssetType: sellingAssetType, sellingAssetCode: sellingAssetCode, sellingAssetIssuer: sellingAssetIssuer, buyingAssetType: buyingAssetType, buyingAssetCode: buyingAssetCode, buyingAssetIssuer: buyingAssetIssuer, limit: 20) { (response) -> (Void) in
            switch response {
            case .success(let orderBook):
                var asks: [ExchangeOrder] = []
                var bids: [ExchangeOrder] = []
                orderBook.asks.forEach({ (ask) in
                    let order = ExchangeOrder(exchangeOrder: ask, side: .sell)
                    asks.append(order)
//                    print("ASK: \(ask.price)")
                })
                orderBook.bids.forEach({ (bid) in
                    let order = ExchangeOrder(exchangeOrder: bid, side: .buy)
                    bids.append(order)
//                    print("BID: \(bid.price)")
                })
                asks.sort { $0.price > $1.price }
                bids.sort { $0.price > $1.price }
                let bestOffer = asks.last?.price ?? 0.0
                let bestBid = bids.first?.price ?? 0.0
                DispatchQueue.main.async {
                    completion(bestOffer, bestBid)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func offer(buy: Asset, sell: Asset, amount: Decimal, price: Price, completion: @escaping (Bool) -> Void) {
        guard let keyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
            DispatchQueue.main.async {
                print("NO SOURCE KEYPAIR")
                completion(false)
            }
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: KeychainHelper.publicKey) { (response) -> (Void) in
            switch response {
            case .success(let accountResponse):
                do {

                    let manageOffer = ManageOfferOperation(sourceAccount: keyPair, selling: sell, buying: buy, amount: amount, price: price, offerId: 0)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [manageOffer],
                                                      memo: nil,
                                                      timeBounds: nil)
                    
                    try transaction.sign(keyPair: keyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction, response: { (response) -> (Void) in
                        switch response {
                        case .success(let details):
                            completion(true)
                            
                            print(details.transactionEnvelope.tx.operations.first?.body)
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
    
    
    static func cancelOffer(offerID: Int64, sell: Token, buy: Token, completion: @escaping (Bool) -> Void) {

        let selling = sell.toRawAsset()
        let buying = buy.toRawAsset()
        
        guard let keyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
            DispatchQueue.main.async {
                print("NO SOURCE KEYPAIR")
                completion(false)
            }
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: KeychainHelper.publicKey) { (response) -> (Void) in
            switch response {
            case .success(let accountResponse):
                do {
                    let price = Price(numerator: 1, denominator: 1)
                    let amount = Decimal(0.0)
                    let manageOffer = ManageOfferOperation(sourceAccount: keyPair, selling: selling, buying: buying, amount: amount, price: price, offerId: offerID)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [manageOffer],
                                                      memo: nil,
                                                      timeBounds: nil)
                    
                    try transaction.sign(keyPair: keyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction, response: { (response) -> (Void) in
                        switch response {
                        case .success(let details):
                            completion(true)
                            print(details.transactionEnvelope.tx)
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
    

    
    static func getOffers(completion: @escaping ([ExchangeOrder]) -> Void) {
        print("PK: \(KeychainHelper.publicKey)")
        let pk = KeychainHelper.publicKey
        Stellar.sdk.offers.getOffers(forAccount:pk) { (response) in
            switch response {
            case .success(let details):
                var orders: [ExchangeOrder] = []
                details.records.forEach({ (offer) in
                    let order = ExchangeOrder(offer: offer)
                    orders.append(order)
                })
                DispatchQueue.main.async {
                    completion(orders)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}


