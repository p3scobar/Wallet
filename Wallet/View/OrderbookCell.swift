//
//  OrderbookCell.swift
//  coins
//
//  Created by Hackr on 1/2/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class OrderBookCell: UITableViewCell {
    
    var offer: ExchangeOrder? {
        didSet {
            if let size = offer?.size {
                self.textLabel?.text = "\(size.rounded(toPlaces: 3))"
            }
            if let price = offer?.price {
                
                self.valueLabel.text = "\(price.rounded(toPlaces: 3))"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = Theme.black
        textLabel?.font = Theme.semibold(16)
        textLabel?.textColor = Theme.white
        let bg = UIView()
        bg.backgroundColor = Theme.selected
        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var valueLabel: UILabel = {
        let frame = CGRect(x: UIScreen.main.bounds.width/2, y: 8, width: UIScreen.main.bounds.width/2-16, height: self.frame.height)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.textAlignment = .right
        label.textColor = Theme.white
        return label
    }()
    
    func setupView() {
        addSubview(valueLabel)
    }
}

