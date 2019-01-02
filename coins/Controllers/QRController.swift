//
//  QRController.swift
//  coins
//
//  Created by Hackr on 12/8/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import QRCode

class QRController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.black
        setupView()
        setQRCode()
    }
    
    
    func setQRCode() {
        let publicKey = KeychainHelper.publicKey
        let qrCode = QRCode(publicKey)
        publicKeyLabel.text = publicKey
        qrView.image = qrCode?.image
    }
    
    
    lazy var container: UIView = {
        let maxHeight = (self.view.frame.height < 540) ? self.view.frame.height*0.8 : 540
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-60, height: maxHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var qrView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = Theme.bold(18)
        button.setTitleColor(Theme.black, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let line0: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let publicKeyLabel: UITextView = {
        let view = UITextView()
        view.textColor = Theme.black
        view.textAlignment = .center
        view.isEditable = false
        view.font = UIFont(name: "courier", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let copyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Copy", for: .normal)
        button.titleLabel?.font = Theme.bold(18)
        button.setTitleColor(Theme.black, for: .normal)
        button.addTarget(self, action: #selector(handleCopy), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCopy() {
        UIPasteboard.general.string = KeychainHelper.publicKey
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {

        view.addSubview(container)
        container.addSubview(qrView)
        container.addSubview(publicKeyLabel)
        container.addSubview(doneButton)
        container.addSubview(copyButton)
        container.addSubview(line0)
        container.addSubview(line1)
        
        container.center = view.center
        
        qrView.topAnchor.constraint(equalTo: container.topAnchor, constant: 40).isActive = true
        qrView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -40).isActive = true
        qrView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 40).isActive = true
        qrView.heightAnchor.constraint(equalToConstant: container.frame.width-80).isActive = true
        
        publicKeyLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        publicKeyLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        publicKeyLabel.topAnchor.constraint(equalTo: qrView.bottomAnchor, constant: 20).isActive = true
        publicKeyLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        line0.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        line0.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        line0.bottomAnchor.constraint(equalTo: copyButton.topAnchor).isActive = true
        line0.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        copyButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        copyButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        copyButton.bottomAnchor.constraint(equalTo: line1.topAnchor).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        line1.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        line1.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        line1.bottomAnchor.constraint(equalTo: doneButton.topAnchor).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        doneButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
    }
    
}

