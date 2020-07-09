//
//  CardCell.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    var token: Token? {
        didSet {
            cardView.token = token
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var cardView: CardView = {
        let width = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: width*0.65)
        let view = CardView(frame: frame)
        return view
    }()
    
    func setupView() {
        addSubview(cardView)
    }
    
}
