//
//  TransferCell.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class TransferCell: PaymentCell {
    
    var transfer: Transfer? {
        didSet {
            if let amount = transfer?.amount {
                titleRightLabel.text = amount
            }
            if let currency = transfer?.currency {
                subtitleRightLabel.text = currency
            }
            if let date = transfer?.timestamp {
                subtitleLeftLabel.text = date.short()
            }
            titleLeftLabel.text = "Deposit"
        }
    }
    
}
