//
//  TransactionHeader.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class PaymentHeader: UIView {
    
    var payment: Payment?
    
    var user: User? {
        didSet {
            if let username = user?.username {
                self.usernameLabel.text = "$\(username)"
            }
            if let userImage = user?.image {
                let url = URL(string: userImage)
                profileImageView.kf.setImage(with: url)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var profileImageView: UIImageView = {
        let frame = CGRect(x: 16, y: 20, width: 80, height: 80)
        let view = UIImageView(frame: frame)
        view.layer.cornerRadius = frame.width/2
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.selected
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    lazy var usernameLabel: UILabel = {
        let frame = CGRect(x: 120, y: 40, width: self.frame.width-140, height: 40)
        let label = UILabel(frame: frame)
        label.textAlignment = .left
        label.textColor = Theme.black
        label.text = "$"
        label.font = Theme.semibold(24)
        return label
    }()
    
    lazy var line: UIView = {
        let frame = CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 0.6)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.border
        return view
    }()
    
    func setupView() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
//        addSubview(line)
    }
    
}

