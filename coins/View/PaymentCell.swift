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
            subtitleLeftLabel.text = "Received"
            if let timestamp = payment?.timestamp {
                titleLeftLabel.text = timestamp.short()
            }
            
            if let amount = payment?.amount,
                let decimal = Decimal(string: amount) {
                titleRightLabel.text = decimal.currency()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        let bg = UIView()
        bg.backgroundColor = Theme.selected
        selectedBackgroundView = bg
        backgroundColor = Theme.tint
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var subtitleLeftLabel: UILabel = {
        let frame = CGRect(x: 16, y: 16, width: UIScreen.main.bounds.width-32, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textColor = Theme.gray
        return label
    }()
    
    lazy var titleLeftLabel: UILabel = {
        let frame = CGRect(x: 16, y: 36, width: UIScreen.main.bounds.width-32, height: 48)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(20)
        label.numberOfLines = 2
        label.textColor = Theme.white
        return label
    }()
    
    lazy var titleRightLabel: UILabel = {
        let frame = CGRect(x: 16, y: 36, width: UIScreen.main.bounds.width-32, height: 48)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(20)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.textColor = Theme.white
        return label
    }()
    
    lazy var subtitleRightLabel: UILabel = {
        let frame = CGRect(x: 16, y: 16, width: UIScreen.main.bounds.width-32, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = Theme.gray
        return label
    }()
    
    func setupView() {
        addSubview(subtitleLeftLabel)
        addSubview(titleLeftLabel)
        addSubview(subtitleRightLabel)
        addSubview(titleRightLabel)
    }
    
    
}

