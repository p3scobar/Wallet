//
//  SectionHeaderView.swift
//  Wallet
//
//  Created by Hackr on 2/17/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class SectionHeaderView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = Theme.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let frame = CGRect(x: 20, y: 0, width: self.frame.width-24, height: self.frame.height)
        let label = UILabel(frame: frame)
        label.font = Theme.semibold(18)
        label.textColor = Theme.black
        return label
    }()
    
    func setupView() {
        addSubview(titleLabel)
    }
    
}
