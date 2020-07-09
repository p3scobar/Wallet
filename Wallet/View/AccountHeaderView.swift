//
//  AccountHeaderView.swift
//  Wallet
//
//  Created by Hackr on 1/9/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import QRCode

protocol AccountHeaderDelegate {
    func handleQRTap(publicKey: String)
}

class AccountHeaderView: UIView {
    
    var delegate: AccountHeaderDelegate?
    
    var publicKey: String? {
        didSet {
            setupQRView()
        }
    }
    
    private var qrcode: QRCode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleQRTap))
        container.addGestureRecognizer(tap)
        publicKey = KeychainHelper.publicKey
    }
    
    @objc func handleQRTap() {
        guard let publicKey = publicKey else { return }
        delegate?.handleQRTap(publicKey: publicKey)
    }
    
    
    func setupQRView() {
        publicKeyLabel.text = KeychainHelper.publicKey
        let code = QRCode(KeychainHelper.publicKey)
        self.qrcode = code
        qrView.image = code?.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var container: UIView = {
        let frame = CGRect(x: 16, y: 32, width: self.frame.width-32, height: 110)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.white
        view.layer.cornerRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    lazy var qrView: UIImageView = {
        let frame = CGRect(x: 10, y: 10, width: 90, height: 90)
        let view = UIImageView(frame: frame)
        
        return view
    }()
    
    
    lazy var publicKeyLabel: UITextView = {
        let frame = CGRect(x: 110, y: container.frame.height/4, width: container.frame.width-120, height: 80)
        let view = UITextView(frame: frame)
        view.textColor = Theme.gray
        view.backgroundColor = .clear
        view.isEditable = false
        view.font = Theme.semibold(15)
        view.textContainerInset = UIEdgeInsets.zero
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    
    @objc func handleCopy() {
        UIPasteboard.general.string = KeychainHelper.publicKey
        UIDevice.vibrate()
    }
    
    func setupView() {
        addSubview(container)
        container.addSubview(qrView)
        container.addSubview(publicKeyLabel)

    }
    
}


