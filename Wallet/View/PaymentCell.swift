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
                let amount = payment?.amount else { return }
            titleLeftLabel.text = timestamp.short()
            titleRightLabel.text = amount.rounded(4) + " \(counterAsset.assetCode)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = Theme.background
        let bg = UIView()
        bg.backgroundColor = Theme.tint
        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLeftLabel: UILabel = {
           let frame = CGRect(x: 20, y: 12, width: UIScreen.main.bounds.width-40, height: 30)
           let label = UILabel(frame: frame)
           label.font = Theme.semibold(18)
           label.numberOfLines = 2
           label.textColor = Theme.white
           return label
       }()
       
       lazy var subtitleLeftLabel: UILabel = {
           let frame = CGRect(x: 20, y: 44, width: UIScreen.main.bounds.width-40, height: 20)
           let label = UILabel(frame: frame)
           label.font = Theme.medium(16)
           label.numberOfLines = 1
           label.textColor = Theme.gray
           return label
       }()
       
       lazy var titleRightLabel: UILabel = {
           let frame = CGRect(x: 20, y: 12, width: UIScreen.main.bounds.width-40, height: 30)
           let label = UILabel(frame: frame)
           label.font = Theme.semibold(18)
           label.numberOfLines = 2
           label.textAlignment = .right
           label.textColor = Theme.white
           return label
       }()
       
       lazy var subtitleRightLabel: UILabel = {
           let frame = CGRect(x: 20, y: 44, width: UIScreen.main.bounds.width-40, height: 20)
           let label = UILabel(frame: frame)
           label.font = Theme.medium(16)
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

