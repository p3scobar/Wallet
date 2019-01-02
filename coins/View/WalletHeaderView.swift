//
//  WalletHeaderView.swift
//  coins
//
//  Created by Hackr on 12/8/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class WalletHeaderView: UIView {
    
    var token: Token? {
        didSet {
            if let balance = token?.balance,
                let decimal = Decimal(string: balance) {
                balanceLabel.text = decimal.currency()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(balanceLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var balanceLabel: UILabel = {
        let frame = CGRect(x: 16, y: self.frame.height-80, width: self.frame.width-32, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(36)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = Theme.white
        return label
    }()
    
    
}
