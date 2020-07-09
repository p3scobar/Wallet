//
//  Card.swift
//  Wallet
//
//  Created by Hackr on 7/5/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation

struct PaymentMethod {
    
    var id: String
    var type: PaymentMethodType
    var brand: String
    var last4: String
    
    var name: String {
        switch type {
        case .applePay:
            return " Apple Pay"
        case .card:
            return brand.uppercased() + " " + last4
        }
    }
    
    init(id: String, type: PaymentMethodType, brand: String?, last4: String?) {
        self.id = id
        self.type = type
        self.brand = brand ?? ""
        self.last4 = last4 ?? ""
    }
    
    init() {
        self.id = ""
        self.type = .applePay
        self.brand = ""
        self.last4 = ""
    }
    
}


enum PaymentMethodType {
    case applePay
    case card
}
