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
        customize()
    }
    
    func customize() {
        backgroundColor = Theme.tint
        selectionStyle = .default
        textLabel?.textColor = .white
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 20, y: 14, width: self.frame.width-40, height: self.frame.height)
        let label = UILabel(frame: frame)
        label.font = Theme.medium(16)
        label.numberOfLines = 1
        label.textColor = Theme.white
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.width-40, height: self.frame.height)
        let label = UILabel(frame: frame)
        label.font = Theme.medium(16)
        label.numberOfLines = 1
        label.textColor = Theme.white
        label.textAlignment = .right
        return label
    }()
    
    
}

