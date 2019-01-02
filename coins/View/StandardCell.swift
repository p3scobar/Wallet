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
        textLabel?.textColor = Theme.white
        backgroundColor = Theme.tint
        let bg = UIView()
        bg.backgroundColor = Theme.selected
        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
