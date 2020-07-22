//
//  Plan.swift
//  Wallet
//
//  Created by Hackr on 7/5/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation

struct Plan {
    
    var id: String
    var assetCode: String
    var amount: Double?
    var isActive: Bool
    var nextCharge: Date
    
    init(id: String, assetCode: String, amount: Double?, isActive: Bool, nextCharge: Date) {
        self.id = id
        self.assetCode = assetCode
        self.amount = amount
        self.isActive = isActive
        self.nextCharge = nextCharge
    }
    
}
