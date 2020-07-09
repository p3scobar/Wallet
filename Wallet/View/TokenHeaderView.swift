//
//  TokenHeaderView.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

protocol TokenHeaderDelegate {
    func handleOrderTap(token: Token?, side: TransactionType)
}

import Foundation
import UIKit

class TokenHeaderView: UIView {
    
    var delegate: TokenHeaderDelegate?
    
    var lastPrice: Decimal = 0.0 {
        didSet {
            let balance = Decimal(string: token.balance) ?? 0.0
//            subtitleLabel.text = (balance*lastPrice).currency(2) + " \(baseAsset.assetCode)"
        }
    }

    var token: Token {
        didSet {
            cardView.token = token
        }
    }
    
    
    init(frame: CGRect, token: Token) {
        self.token = token
        super.init(frame: frame)
        backgroundColor = .black
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

        lazy var cardView: CardView = {
            let width = self.frame.width
            let frame = CGRect(x: 0, y: 0, width: width, height: width*0.65)
            let view = CardView(frame: frame)
            return view
        }()
        
        
        
        lazy var buyButton: Button = {
            let frame = CGRect(x: 20, y: self.frame.height-80, width: self.frame.width/2-30, height: 54)
            let button = Button(frame: frame, title: "Buy")
            button.titleLabel?.font = Theme.semibold(20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = Theme.button
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(handleBuyTap), for: .touchUpInside)
            return button
        }()

        lazy var sellButton: Button = {
            let frame = CGRect(x: self.frame.width/2+10, y: self.frame.height-80, width: self.frame.width/2-30, height: 54)
            let button = Button(frame: frame, title: "Sell")
            button.titleLabel?.font = Theme.semibold(20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = Theme.button
            button.layer.cornerRadius = 8
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(handleSellTap), for: .touchUpInside)
            return button
        }()
        
        lazy var trustButton: Button = {
            let frame = CGRect(x: 16, y: self.frame.height-80, width: self.frame.width-32, height: 54)
            let button = Button(frame: frame, title: "Add to Wallet")
            button.titleLabel?.font = Theme.semibold(20)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = Theme.highlight
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(addTrustline), for: .touchUpInside)
            return button
        }()

        @objc func addTrustline() {
//            delegate?.addTrustline(token)
        }
        
        @objc func handleBuyTap() {
            delegate?.handleOrderTap(token: token, side: .buy)
        }
        
        @objc func handleSellTap() {
            delegate?.handleOrderTap(token: token, side: .sell)
        }
        
        func setupView() {
    //        addSubview(priceLabel)
    //        addSubview(valueLabel)
            setupOrderButtons()
            addSubview(cardView)
        }
        
        
        func setupOrderButtons() {
            print("TRUSTED")
            addSubview(buyButton)
            addSubview(sellButton)
    //        trustButton.isHidden = true
            buyButton.isHidden = false
            sellButton.isHidden = false
        }
        
        func noTrustline() {
            print("NO TRUSTLINE")
            addSubview(trustButton)
            trustButton.isHidden = false
            buyButton.isHidden = true
            sellButton.isHidden = true
        }
    
    
}
    
    
    
