//
//  PaymentTableHeader.swift
//  Wallet
//
//  Created by Hackr on 4/24/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import UIKit

class SendView: UITableViewHeaderFooterView {
    

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var publicKeyLabel: UILabel = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        let view = UILabel(frame: frame)
        view.font = Theme.semibold(18)
        view.text = "Public Key"
        return view
    }()
    
    lazy var amountLabel: UILabel = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 120)
        let view = UILabel(frame: frame)
        view.font = Theme.semibold(18)
        view.text = "Amount"
        return view
    }()
    
    func setupView() {
        addSubview(publicKeyLabel)
        addSubview(amountLabel)
        
    }
    
}
