//
//  Plan.swift
//  Wallet
//
//  Created by Hackr on 7/5/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation

struct Plan {
    
    var price: Decimal
    var id: String
    
    init(id: String, price: Decimal) {
        self.id = id
        self.price = price
    }
    
}
