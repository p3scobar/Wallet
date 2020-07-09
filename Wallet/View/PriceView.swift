//
//  PriceView.swift
//  Wallet
//
//  Created by Hackr on 3/16/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

protocol PriceViewDelegate {
    func handleBuyTap()
}

class PriceView: UIView {
    
    var delegate: PriceViewDelegate?
    
    var price: Double = lastPrice {
        didSet {
            priceLabel.text = price.currency(2)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 20, y: 20, width: self.frame.width-40, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.textAlignment = .left
        label.text = "Gold Price"
        label.textColor = Theme.darkGray
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let frame = CGRect(x: 20, y: 44, width: self.frame.width-40, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(24)
        label.textAlignment = .left
        label.textColor = Theme.black
        label.text = "$1,800.00"
        return label
    }()
    
    lazy var buyButton: Button = {
        let frame = CGRect(x: self.frame.width-110, y: 10, width: 100, height: self.frame.height-20)
        let button = Button(frame: frame, title: "Buy")
        button.titleLabel?.font = Theme.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.black
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleBuyTap), for: .touchUpInside)
        return button
    }()
    
    @objc func handleBuyTap() {
        delegate?.handleBuyTap()
    }
    
    func setupView() {
        backgroundColor = Theme.lightGray
        addSubview(priceLabel)
        addSubview(titleLabel)
        addSubview(buyButton)
    }
    
}
