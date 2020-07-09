//
//  ExchangeOrder.swift
//  coins
//
//  Created by Hackr on 1/2/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import stellarsdk

public struct ExchangeOrder {
    
    var size: Double
    var price: Double
    var total: Double
    var side: TransactionType
    var id: Int?
    var buy: Token?
    var sell: Token?
    
    init(size: Double, price: Double, side: TransactionType) {
        self.size = size
        self.price = price
        self.side = side
        self.total = price*size
    }
    
    init(exchangeOrder: OrderbookOfferResponse, side: TransactionType) {
        let price = Double(exchangeOrder.price) ?? 0
        let size = orderBookFormattedSize(exchangeOrder, side: side)
        self.init(size: size, price: price, side: side)
    }

}


internal func orderBookFormattedSize(_ order: OrderbookOfferResponse, side: TransactionType) -> Double {
    if side == .buy {
        let total = Double(order.amount) ?? 0
//        return total
        
        let price = Double(order.price) ?? 0
        return total/price
    } else {
        let amount = Double(order.amount) ?? 0
        return amount
    }
}


extension ExchangeOrder {
    
    init(offer: OfferResponse) {
        let side: TransactionType = offer.selling.assetCode == baseAsset.assetCode ? .sell : .buy
        let buyingAssetAmount = offer.priceR.numerator
        let sellingAssetAmount = offer.priceR.denominator
        
        var price: Double = 0
        var size: Double = 0
        var total: Double = 0
        
        if side == .buy {
            price = Double(sellingAssetAmount)/100
            size = Double(offer.amount) ?? 0
            total = size
        } else {
            price = Double(buyingAssetAmount)/100
            size = Double(offer.amount) ?? 0
            total = size
        }
        
        self.init(size: size, price: price, side: side)
        self.id = offer.id
        
        buy = Token(offer.buying)
        sell = Token(offer.selling)
    }
    
    
}

