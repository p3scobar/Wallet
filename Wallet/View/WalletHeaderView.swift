//
//  WalletHeaderView.swift
//  coins
//
//  Created by Hackr on 12/8/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

protocol WalletHeaderDelegate {
    func handleQRTap()
    func handleCardTap()
}

class WalletHeaderView: UIView {
    
    var delegate: WalletHeaderDelegate?
    
    var token: Token? {
        didSet {
            let balanceString = token?.balance ?? ""
            if let balance = Decimal(string: balanceString) {
                balanceLabel.text = balance.rounded(2)
                currencyLabel.text = (balance*goldSpotPrice).currency() + " USD"
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.lightBackground
        setupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
        card.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var card: UIView = {
        let frame = CGRect(x: 12, y: 20, width: UIScreen.main.bounds.width-24, height: 220)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.card
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.borderColor = Theme.black.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var shadow: UIView = {
        let view = UIView(frame: card.frame)
        view.layer.cornerRadius = card.layer.cornerRadius
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 20, y: 12, width: card.frame.width-40, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(24)
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "Balance"
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let frame = CGRect(x: 20, y: 12, width: card.frame.width-40, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(24)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "0.000"
        return label
    }()
    
    lazy var currencyLabel: UILabel = {
        let frame = CGRect(x: 20, y: self.card.frame.height-44, width: card.frame.width-40, height: 30)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.text = "HMT"
        return label
    }()
    
    lazy var qrView: UIButton = {
        let frame = CGRect(x: self.card.frame.width-60, y: self.card.frame.height-60, width: 60, height: 60)
        let button = UIButton(frame: frame)
        let qrImage = UIImage(named: "qrcode")?.withRenderingMode(.alwaysTemplate)
        button.setImage(qrImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleQRTap), for: .touchUpInside)
        return button
    }()
    
    @objc func handleQRTap(_ tap: UITapGestureRecognizer) {
        delegate?.handleQRTap()
    }
    
    @objc func handleCardTap(_ tap: UITapGestureRecognizer) {
        delegate?.handleCardTap()
    }
    
    
    func setupView() {
        addSubview(shadow)
        addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(balanceLabel)
        card.addSubview(currencyLabel)
        card.addSubview(qrView)
    }
  
    
}
