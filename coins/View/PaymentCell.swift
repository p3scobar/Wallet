//
//  TransactionCell.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    var payment: Payment? {
        didSet {
            
            if let timestamp = payment?.timestamp {
                titleLabel.text = timestamp.short()
            }
            
            if let amount = payment?.amount,
                let decimal = Decimal(string: amount) {
                balanceLabel.text = decimal.rounded(3)
            }
        }
    }
    
    var charge: Charge? {
        didSet {
            
            if let timestamp = charge?.timestamp {
                titleLabel.text = timestamp.short()
            }
            
            if let amount = charge?.amount,
                let decimal = Decimal(string: amount) {
                balanceLabel.text = decimal.rounded(3)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 16, y: 0, width: UIScreen.main.bounds.width/2-16, height: 64)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let frame = CGRect(x: UIScreen.main.bounds.width/2, y: 0, width: UIScreen.main.bounds.width/2-16, height: 64)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(balanceLabel)
    }
    
    
}

