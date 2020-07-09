//
//  OrderButtonView.swift
//  Wallet
//
//  Created by Hackr on 9/25/19.
//  Copyright © 2019 Sugar. All rights reserved.
//


import Foundation
import UIKit

protocol OrderButtonDelegate {
    func handleOrderTap(side: TransactionType)
}

class OrderButtonView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(buyButton)
        addSubview(sellButton)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var delegate: OrderButtonDelegate?

    
    lazy var buyButton: Button = {
        let frame = CGRect(x: (self.frame.width)/2+8, y: 20, width: (self.frame.width-44)/2, height: 64)
        let button = Button(frame: frame, title: "Buy")
        button.setTitle("Buy", for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.tint
        button.addTarget(self, action: #selector(handleBuy), for: .touchUpInside)
        return button
    }()
    
    lazy var sellButton: Button = {
        let frame = CGRect(x: 16, y:  20, width: (self.frame.width-44)/2, height: 64)
        let button = Button(frame: frame, title: "Sell")
        button.setTitle("Sell", for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.tint
        button.addTarget(self, action: #selector(handleSell), for: .touchUpInside)
        return button
    }()
    
    

    @objc func handleBuy() {
        delegate?.handleOrderTap(side: .buy)
    }
    
    
    @objc func handleSell() {
        delegate?.handleOrderTap(side: .sell)
    }
    
}


