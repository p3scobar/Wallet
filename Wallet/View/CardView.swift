//
//  CardView.swift
//  Wallet
//
//  Created by Hackr on 5/7/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    
    var token: Token? {
        didSet {
            if let name = token?.name {
                titleLabel.text = name
            }
            let balance = Double(token?.balance ?? "") ?? 0.0

            amountLabel.text = "\(balance.rounded(toPlaces: 3))"
            guard let assetCode = token?.assetCode else { return }
            let price = RateManager.rates[assetCode] ?? 0.0
            valueLabel.text = (balance*price).currency(2)
            
            setImage(assetCode)
        }
    }
    
    
    fileprivate func setImage(_ assetCode: String) {
        switch assetCode {
        case "XAU":
            cardImageView.image = UIImage(named: "card")
        case "XAG":
            cardImageView.image = UIImage(named: "silver")
        default:
            cardImageView.image = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var cardImageView: UIImageView = {
        let frame = card.frame
        let view = UIImageView(frame: frame)
        view.backgroundColor = Theme.card
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var card: UIVisualEffectView = {
        let width = UIScreen.main.bounds.width-40
        let frame = CGRect(x: 20, y: 20, width: width, height: width*0.618)
        let view = UIVisualEffectView(frame: frame)
        view.effect = UIBlurEffect(style: .light)
        view.frame = frame
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.borderColor = Theme.line.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    lazy var shadow: UIView = {
        let view = UIView(frame: card.frame)
        view.layer.cornerRadius = card.layer.cornerRadius
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = Theme.black.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 40, y: 40, width: card.frame.width-96, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(24)
        label.numberOfLines = 1
        label.textColor = .white
        label.text = "Gold"
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let frame = CGRect(x: 40, y: card.frame.height-40, width: self.frame.width-40, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(22)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.text = "0.000"
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let frame = CGRect(x: 40, y: card.frame.height-40, width: card.frame.width-40, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(22)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .white
        label.text = "0.000"
        return label
    }()
    
    func setupView() {
        addSubview(shadow)
        addSubview(cardImageView)
        addSubview(card)
        addSubview(titleLabel)
        
        addSubview(amountLabel)
        addSubview(valueLabel)
    }

}
