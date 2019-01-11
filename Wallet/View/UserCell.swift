//
//  UserCell.swift
//  Wallet
//
//  Created by Hackr on 1/8/19.
//  Copyright © 2019 Sugar. All rights reserved.
//


import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    
    var user: User? {
        didSet {
            if let username = user?.username {
                titleLabel.text = "$\(username)"
            }
            
            if let image = user?.image {
                guard let url = URL(string: image) else { return }
                profileImageView.kf.setImage(with: url)
            } 
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImageView.image = nil
        setupView()
        backgroundColor = .white
        let bg = UIView()
        bg.backgroundColor = Theme.selected
        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var profileImageView: UIImageView = {
    let frame = CGRect(x: 16, y: 8, width: 48, height: 48)
        let view = UIImageView(frame: frame)
        view.backgroundColor = Theme.white
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 80, y: self.frame.height/2-2, width: self.frame.width-20, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.textColor = Theme.black
        label.numberOfLines = 1
        return label
    }()
    
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(profileImageView)
        
    }
    
    
    
}

