//
//  ButtonCell.swift
//  coins
//
//  Created by Hackr on 12/26/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(button)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIView = {
        let frame = CGRect(x: 16, y: 8, width: 44, height: 44)
        let view = UIView(frame: frame)
        view.layer.cornerRadius = 22
        view.backgroundColor = Theme.black
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 80, y: 12, width: UIScreen.main.bounds.width-80, height: 32)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(20)
        label.numberOfLines = 1
        label.textColor = Theme.black
        return label
    }()
    
    
}


