//
//  ButtonTableFooterView.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonTableFooterDelegate {
    func didTapButton()
}

class ButtonTableFooterView: UIView {
    
    var buttonTitle: String
    
    init(frame: CGRect, title: String) {
        self.buttonTitle = title
        super.init(frame: frame)
        addSubview(indicator)
        addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: ButtonTableFooterDelegate?
    
    var isLoading: Bool = false {
        didSet {
            if isLoading == true {
                indicator.startAnimating()
                button.isHidden = true
                indicator.isHidden = false
            } else {
                indicator.stopAnimating()
                button.isHidden = false
                indicator.isHidden = true
            }
        }
    }
    
    lazy var indicator: UIActivityIndicatorView = {
        let frame = CGRect(x: center.x-24, y: center.y-24, width: 48, height: 48)
        let view = UIActivityIndicatorView(frame: frame)
        view.style = .white
        return view
    }()
    
    
    lazy var button: Button = {
        let frame = CGRect(x: 20, y: 20, width: self.frame.width-40, height: 64)
        let button = Button(frame: frame, title: buttonTitle)
        button.setTitle(buttonTitle, for: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Theme.white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleCancel), for: .touchDown)
        return button
    }()
    
    @objc func handleCancel() {
        delegate?.didTapButton()
    }
    
    
    
}

