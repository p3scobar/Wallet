//
//  AccountHeaderView.swift
//  Wallet
//
//  Created by Hackr on 1/9/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

protocol AccountHeaderDelegate {
    func handleImageTap()
}

class AccountHeaderView: UIView {
    
    var delegate: AccountHeaderDelegate?
    
    var imageUrl: String? {
        didSet {
            guard let url = URL(string: imageUrl ?? "") else { return }
            profileImageView.kf.setImage(with: url)
        }
    }
    
    var name: String? {
        didSet {
            self.nameLabel.text = name ?? ""
        }
    }
    
    var username: String? {
        didSet {
            guard let username = username else { return }
            self.usernameLabel.text = "$\(username)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        profileImageView.addGestureRecognizer(tap)
        imageUrl = CurrentUser.image
        name = CurrentUser.name
        username = CurrentUser.username
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleImageTap() {
        delegate?.handleImageTap()
    }
    
    lazy var profileImageView: UIImageView = {
        let frame = CGRect(x: center.x-60, y: 20, width: 120, height: 120)
        let view = UIImageView(frame: frame)
        view.layer.cornerRadius = 60
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Theme.selected
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    lazy var nameLabel: UILabel = {
        let frame = CGRect(x: 0, y: 160, width: self.frame.width, height: 40)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = Theme.black
        label.font = Theme.semibold(32)
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let frame = CGRect(x: 0, y: 200, width: self.frame.width, height: 40)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = Theme.gray
        label.font = Theme.semibold(24)
        return label
    }()
    
    
    
}
