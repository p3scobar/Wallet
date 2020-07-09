//
//  TradeCell.swift
//  Wallet
//
//  Created by Hackr on 2/6/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit


import UIKit

class TradeCell: UITableViewCell {
    
    var trade: Trade? {
        didSet {
            guard trade != nil else { return }
            let side = trade?.side ?? ""
            let assetCode = trade?.baseAssetCode ?? ""
            let counterAssetCode = trade?.counterAssetCode ?? ""
            let size = trade?.size ?? ""
            let total = trade?.total ?? ""
            
            print("TRADE SIZE: \(size)")
            print("TRADE TOTAL: \(total)")
            print("*********************")
            
            titleLeftLabel.text = side.capitalized
            
            subtitleRightLabel.text = total.currency() + " \(assetCode)"
            
            titleRightLabel.text = size.rounded(3) + " \(counterAssetCode)"
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = Theme.tint
        let bg = UIView()
        bg.backgroundColor = Theme.lightBackground
        selectedBackgroundView = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var titleLeftLabel: UILabel = {
        let frame = CGRect(x: 20, y: 12, width: UIScreen.main.bounds.width-40, height: 40)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textColor = Theme.white
        return label
    }()
    
    lazy var subtitleLeftLabel: UILabel = {
        let frame = CGRect(x: 20, y: 44, width: UIScreen.main.bounds.width-40, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.medium(14)
        label.numberOfLines = 1
        label.textColor = Theme.lightGray
        return label
    }()
    
    lazy var titleRightLabel: UILabel = {
        let frame = CGRect(x: 20, y: 12, width: UIScreen.main.bounds.width-40, height: 30)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(16)
        label.numberOfLines = 2
        label.textAlignment = .right
        label.textColor = Theme.white
        return label
    }()
    
    lazy var subtitleRightLabel: UILabel = {
        let frame = CGRect(x: 20, y: 44, width: UIScreen.main.bounds.width-40, height: 20)
        let label = UILabel(frame: frame)
        label.font = Theme.medium(14)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = Theme.lightGray
        return label
    }()
    
    func setupView() {
        addSubview(subtitleLeftLabel)
        addSubview(titleLeftLabel)
        addSubview(subtitleRightLabel)
        addSubview(titleRightLabel)
    }
    
    
}

