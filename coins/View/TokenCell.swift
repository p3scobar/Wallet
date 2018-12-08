//
//  TokenCell.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class TokenCell: UITableViewCell {
    
    var token: Token? {
        didSet {
            if let name = token?.assetCode {
                titleLabel.text = name
                if let image = UIImage(named: name) {
                    self.iconImageView.image = image
                }
            }

            if let balance = Decimal(string: token!.balance) {
                balanceLabel.text = balance.rounded(3)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let iconImageView: UIImageView = {
        let frame = CGRect(x: 16, y: 10, width: 44, height: 44)
        let view = UIImageView(frame: frame)
        view.layer.cornerRadius = 24
        view.backgroundColor = Theme.lightGray
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 72, y: 0, width: UIScreen.main.bounds.width/2-72, height: 64)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let frame = CGRect(x: UIScreen.main.bounds.width/2, y: 0, width: UIScreen.main.bounds.width/2-16, height: 64)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(balanceLabel)
        addSubview(iconImageView)
    }
    

}
