//
//  TokenCellDetails.swift
//  coins
//
//  Created by Hackr on 1/6/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class TokenCellDetails: TokenCell {
    
    override var token: Token? {
        didSet {
            super.token = token
            detailsLabel.text = token?.name
        }
    }
    
    lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.regular(14)
        label.textColor = Theme.gray
        label.numberOfLines = 1
        return label
    }()
    
    override func setupView() {
        
        addSubview(detailsLabel)
        addSubview(titleLabel)
        addSubview(balanceLabel)
        addSubview(iconView)
        
        balanceLabel.textColor = Theme.black
        
        iconView.frame = CGRect(x: 16, y: 12, width: 48, height: 48)
        titleLabel.frame = CGRect(x: 80, y: 14, width: UIScreen.main.bounds.width-80, height: 20)
        detailsLabel.frame = CGRect(x: 80, y: 38, width: UIScreen.main.bounds.width-80, height: 20)
        balanceLabel.frame =  CGRect(x: 16, y: 12, width: UIScreen.main.bounds.width-32, height: 20)
        
    }
}
