//
//  Transfer.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//
//
//import Foundation
//
//
//import Foundation
//
//enum TransferType: String {
//    case deposit
//    case withdrawal
//}
//
//
//class Transfer: NSObject {
//    
//    var id: String
//    var type: TransferType
//    var status: String
//    var timestamp: Date
//    
//    var bitcoinAddress: String
//    var amount: String
//    var price: String
//    var currency: String
//    
//    init(id: String, type: TransferType, currency: String, amount: String, bitcoinAddress: String, price: String) {
//        self.id = id
//        self.type = type
//        self.currency = currency
//        self.amount = amount
//        self.bitcoinAddress = bitcoinAddress
//        self.timestamp = Date()
//        self.price = price
//        self.status = "pending"
//    }
//    
//    init(data: [String:Any]) {
//        self.id = data["id"] as? String ?? ""
//        self.bitcoinAddress = data["address"] as? String ?? ""
//        self.amount = data["amount"] as? String ?? ""
//        self.id = data["id"] as? String ?? ""
//        self.timestamp = data["timestamp"] as? Date ?? Date()
//        
//        let rawValueType = data["type"] as? String ?? ""
//        self.type = TransferType(rawValue: rawValueType) ?? .deposit
//        self.currency = data["currency"] as? String ?? ""
//        self.status = data["status"] as? String ?? ""
//        self.price = data["price"] as? String ?? ""
//        
//    }
//    
//}
//
