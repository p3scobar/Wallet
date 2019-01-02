//
//  TransactionHeader.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class PaymentHeader: UIView {
    
    var payment: Payment? {
        didSet {
            if let amount = payment?.amount {
                amountLabel.text = amount.currency()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var amountLabel: UILabel = {
        let frame = CGRect(x: 0, y: background.frame.height/2-20, width: self.frame.width, height: 40)
        let view = UILabel(frame: frame)
        view.textColor = Theme.white
        view.textAlignment = .center
        view.font = Theme.bold(36)
        return view
    }()
    
    lazy var background: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 32, width: self.frame.width, height: self.frame.height-32))
        view.backgroundColor = Theme.tint
        return view
    }()
    
    lazy var topLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.6))
        view.backgroundColor = Theme.border
        return view
    }()
    
//    lazy var bottomLine: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: self.frame.height-0.6, width: self.frame.width, height: 0.6))
//        view.backgroundColor = Theme.border
//        return view
//    }()
    
    func setupView() {
        addSubview(background)
        background.addSubview(topLine)
        background.addSubview(amountLabel)
//        background.addSubview(bottomLine)
    }
    
}

