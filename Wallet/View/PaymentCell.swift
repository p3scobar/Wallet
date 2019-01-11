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
            subtitleLeftLabel.text = payment?.isReceived == true ? "Received " : "Sent"
            guard let timestamp = payment?.timestamp,
                let amount = payment?.amount,
                let decimalAmount = Decimal(string: amount) else { return }
            titleLeftLabel.text = timestamp.short()
            titleRightLabel.text = decimalAmount.rounded(2)
            
            subtitleRightLabel.text = (decimalAmount*goldSpotPrice).currency()
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .white
        let bg = UIView()
        bg.backgroundColor = Theme.white
        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLeftLabel: UILabel = {
        let frame = CGRect(x: 16, y: 16, width: UIScreen.main.bounds.width-32, height: 30)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(20)
        label.numberOfLines = 2
        label.textColor = Theme.black
        return label
    }()
    
    lazy var subtitleLeftLabel: UILabel = {
        let frame = CGRect(x: 16, y: 50, width: UIScreen.main.bounds.width-32, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textColor = Theme.gray
        return label
    }()
    
    lazy var titleRightLabel: UILabel = {
        let frame = CGRect(x: 16, y: 16, width: UIScreen.main.bounds.width-32, height: 30)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(20)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.textColor = Theme.black
        return label
    }()
    
    lazy var subtitleRightLabel: UILabel = {
        let frame = CGRect(x: 16, y: 50, width: UIScreen.main.bounds.width-32, height: 20)
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

