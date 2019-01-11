//
//  StandardCell.swift
//  coins
//
//  Created by Hackr on 1/2/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class StandardCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = Theme.semibold(18)
        textLabel?.textColor = Theme.black
        backgroundColor = Theme.white
        
        let bg = UIView()
        bg.backgroundColor = Theme.selected
        selectedBackgroundView = bg
        
        addSubview(titleLabel)
        addSubview(iconView)
        iconView.addSubview(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 68, y: 16, width: UIScreen.main.bounds.width-84, height: 32)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.numberOfLines = 1
        label.textColor = Theme.black
        return label
    }()
    
    lazy var iconView: UIView = {
        let frame = CGRect(x: 12, y: 14, width: 36, height: 36)
        let icon = UIView(frame: frame)
        icon.layer.cornerRadius = 12
        return icon
    }()
    
    lazy var icon: UIImageView = {
        let frame = CGRect(x: 8, y: 8, width: 20, height: 20)
        let icon = UIImageView(frame: frame)
        icon.tintColor = .white
        return icon
    }()
    
    
    
}
