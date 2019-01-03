//
//  TokenHeaderView.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

protocol TokenHeaderDelegate {
    func handleOrderTap(token: Token, side: OrderType)
}

import Foundation
import UIKit

class TokenHeaderView: UIView {
    
    var delegate: TokenHeaderDelegate?
    
    var token: Token {
        didSet {
            subtitleLabel.text = token.name
            priceLabel.text = token.lastPrice.currency()
        }
    }
    
    init(frame: CGRect, token: Token) {
        self.token = token
        super.init(frame: frame)
        backgroundColor = Theme.tint
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16, y: 12, width: self.frame.width-32, height: 30))
        label.textAlignment = .left
        label.font = Theme.medium(20)
        label.textColor = Theme.gray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16, y: 60, width: self.frame.width-32, height: 30))
        label.textAlignment = .left
        label.font = Theme.semibold(28)
        label.textColor = .white
        return label
    }()
    
    lazy var buyButton: UIButton = {
        let frame = CGRect(x: 16, y: 140, width: self.frame.width/2-24, height: 54)
        let button = UIButton(frame: frame)
        button.setTitle("Buy", for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.button
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleBuyTap), for: .touchUpInside)
        return button
    }()
    
    lazy var sellButton: UIButton = {
        let frame = CGRect(x: self.frame.width/2+8, y: 140, width: self.frame.width/2-24, height: 54)
        let button = UIButton(frame: frame)
        button.setTitle("Sell", for: .normal)
        button.titleLabel?.font = Theme.semibold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.button
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSellTap), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBuyTap() {
        delegate?.handleOrderTap(token: token, side: .buy)
    }
    
    @objc func handleSellTap() {
        delegate?.handleOrderTap(token: token, side: .sell)
    }
    
    func setupView() {
        addSubview(subtitleLabel)
        addSubview(priceLabel)
        addSubview(buyButton)
        addSubview(sellButton)
    }
}

