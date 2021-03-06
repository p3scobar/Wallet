//
//  TokenCell.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class TokenCell: UITableViewCell {
    
    var token: Token? {
        didSet {
            if let name = token?.assetCode {
                titleLabel.text = name
                if let first = name.first {
                    iconView.text = String(first)
                }
            }

            if let balance = Decimal(string: token?.balance ?? "") {
                balanceLabel.text = balance.rounded(3)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .white
//        let bg = UIView()
//        bg.backgroundColor = Theme.selected
//        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconView: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.backgroundColor = Theme.selected
        label.textAlignment = .center
        label.layer.cornerRadius = 24
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(18)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(balanceLabel)
        addSubview(iconView)
        
        iconView.frame = CGRect(x: 16, y: 12, width: 48, height: 48)
        titleLabel.frame = CGRect(x: 80, y: 12, width: UIScreen.main.bounds.width/2-80, height: 48)
        balanceLabel.frame =  CGRect(x: UIScreen.main.bounds.width/2, y: 12, width: UIScreen.main.bounds.width/2-16, height: 48)
        
    }
    

}
