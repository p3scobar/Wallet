//
//  FloatingButtonView.swift
//  Wallet
//
//  Created by Hackr on 2/3/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

protocol FloatingButtonDelegate {
    func handleTap()
}

class FloatingButtonView: UIView {
    
    var delegate: FloatingButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var buyButton: UIButton = {
            let frame = CGRect(x: 12 , y: 8, width: self.frame.width-24, height: 64)
            let button = UIButton(frame: frame)
            button.setTitle("Send", for: .normal)
            button.titleLabel?.font = Theme.semibold(20)
            button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = Theme.black
            button.addTarget(self, action: #selector(handleTap), for: .touchDown)
            return button
        }()
    
    @objc func handleTap() {
        delegate?.handleTap()
    }
    
    func setupView() {
        addSubview(buyButton)
    }
    
}


