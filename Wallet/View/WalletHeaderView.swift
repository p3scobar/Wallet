//
//  AssetCellLarge.swift
//  coins
//
//  Created by Hackr on 12/8/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

protocol WalletHeaderDelegate {
    func handleButtonTap()
    func handleCardTap()
    func handlePriceViewTap()
    func presentOrderController(side: TransactionType)
}

class WalletHeaderView: UIView {
    
    var delegate: WalletHeaderDelegate?
    
    var token: Token? {
        didSet {
            self.card.token = token
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
        card.addGestureRecognizer(tap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var card: CardView = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width-40, height: self.frame.width*0.62)
        let view = CardView(frame: frame)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    @objc func handleCardTap(_ tap: UITapGestureRecognizer) {
         self.delegate?.handleCardTap()
    }
    
    @objc func handleQRTap(_ tap: UITapGestureRecognizer) {
        delegate?.handleButtonTap()
    }
    
    
    
    lazy var priceView: PriceView = {
        let frame = CGRect(x: 20, y: card.frame.maxY+30, width: self.frame.width-40, height: 100)
        let view = PriceView(frame: frame)
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 16
        view.delegate = self
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    
    func setupView() {
        backgroundColor = Theme.background
        addSubview(card)
        addSubview(priceView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePriceViewTap))
        priceView.addGestureRecognizer(tap)
    }
    
    @objc func handlePriceViewTap() {
        delegate?.handlePriceViewTap()
    }
    
}


extension WalletHeaderView: PriceViewDelegate {
    
    @objc func handleBuyTap() {
        delegate?.handleButtonTap()
    }
    
    
    
}
