//
//  OrderBookHeader.swift
//  Wallet
//
//  Created by Hackr on 3/3/20.
//  Copyright © 2020 Sugar. All rights reserved.
//


import Foundation
import UIKit
import QRCode

protocol OrderbookHeaderDelegate: class {
    func handleOrderTap(token: Token, side: TransactionType)
}

class OrderbookHeaderView: UIView {
    
    var delegate: OrderbookHeaderDelegate?
    
    var asset: Token? {
        didSet {
            guard let asset = asset else { return }
            assetCodeLabel.text = "\(asset.assetCode)/\(baseAsset.assetCode)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.background
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var priceLabel: UILabel = {
        let field = UILabel(frame: CGRect(x: 20, y: 0, width: frame.width-40, height: 40))
        field.font = Theme.bold(28)
        field.numberOfLines = 1
        field.adjustsFontSizeToFitWidth = true
        field.adjustsFontForContentSizeCategory = true
        field.text = "$0"
        field.textColor = .white
        field.textAlignment = .left
        return field
    }()
    
    lazy var assetCodeLabel: UILabel = {
          let field = UILabel(frame: CGRect(x: 20, y: 40, width: frame.width-40, height: 40))
          field.font = Theme.bold(18)
          field.numberOfLines = 1
          field.adjustsFontSizeToFitWidth = true
          field.adjustsFontForContentSizeCategory = true
          field.text = ""
          field.textColor = .lightGray
          field.textAlignment = .left
          return field
      }()

    
    lazy var buyButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: self.frame.height-80, width: self.frame.width/2-30, height: 52))
        button.setTitle("Buy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.semibold(18)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.backgroundColor = Theme.darkGray
        button.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        return button
    }()
    
    lazy var sellButton: UIButton = {
        let button = UIButton(frame: CGRect(x: self.center.x+5, y: self.frame.height-80, width: self.frame.width/2-30, height: 52))
        button.setTitle("Sell", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.semibold(18)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.backgroundColor = Theme.darkGray
        button.addTarget(self, action: #selector(didTapSell), for: .touchUpInside)
        return button
    }()
    
    
    @objc func didTapBuy() {
        guard let asset = asset else { return }
        delegate?.handleOrderTap(token: asset, side: .buy)
    }
    
    @objc func didTapSell() {
        guard let asset = asset else { return }
        delegate?.handleOrderTap(token: asset, side: .sell)
    }
    
    
    func setupView() {
        addSubview(priceLabel)
        addSubview(assetCodeLabel)
//        addSubview(buyButton)
//        addSubview(sellButton)
        
    }
    
}


