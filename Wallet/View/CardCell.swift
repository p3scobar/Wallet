//
//  CardCell.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    var token: Token? {
        didSet {
            if let name = token?.assetCode {
                titleLabel.text = name
            }

            if let balance = Decimal(string: token!.balance) {
                balanceLabel.text = balance.rounded(3)
            }
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.white
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var card: UIView = {
        let frame = CGRect(x: 12, y: 20, width: UIScreen.main.bounds.width-24, height: 220)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.card
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 0.5
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var shadow: UIView = {
        let view = UIView(frame: card.frame)
        view.layer.cornerRadius = card.layer.cornerRadius
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 24, y: 12, width: card.frame.width-48, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.bold(24)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let frame = CGRect(x: 24, y: 12, width: card.frame.width-48, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(24)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    
    func setupView() {
        addSubview(shadow)
        addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(balanceLabel)
    }
    
}
