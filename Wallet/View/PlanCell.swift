//
//  PlanCell.swift
//  Wallet
//
//  Created by Hackr on 3/20/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class PlanCell: TradeCell {
    
    var plan: String = "" {
        didSet {
//            guard trade != nil else { return }
//            let side = trade?.side ?? ""
//            let size = Decimal(string: trade?.size ?? "") ?? 0.0
//            let price = Decimal(string: trade?.price ?? "") ?? 0.0
//            let total = Decimal(string: trade?.total ?? "") ?? 0.0
//            let assetCode = trade?.baseAssetCode ?? ""
            
            titleLeftLabel.text = ""
            subtitleLeftLabel.text = "XAU 0.002390"
            
            titleRightLabel.text = ""
            subtitleRightLabel.text = ""
            
        }
    }
    
}
