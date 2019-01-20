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
        view.backgroundColor = Theme.white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        setupView()
        setQRCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setQRCode() {
        let publicKey = KeychainHelper.publicKey
        let qrCode = QRCode(publicKey)
        publicKeyLabel.text = publicKey
        qrView.image = qrCode?.image
    }
    
    lazy var card: UIView = {
        let maxHeight = (self.view.frame.height < 540) ? self.view.frame.height*0.8 : 540
        let maxWidth = (self.view.frame.width > 380) ? 320 : self.view.frame.width*0.8
        let view = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight))
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.shadowRadius = 16
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.4
        view.layer.borderColor = Theme.border.cgColor
        view.layer.borderWidth = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var qrView: UIImageView = {
        let frame = CGRect(x: card.center.x-120, y: 40, width: 240, height: 240)
        let view = UIImageView(frame: frame)
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
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleCopy() {
        UIPasteboard.general.string = KeychainHelper.publicKey
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.addSubview(card)
        card.addSubview(qrView)
        card.addSubview(publicKeyLabel)
        card.addSubview(doneButton)
        card.addSubview(copyButton)
        card.addSubview(line0)
        card.addSubview(line1)
        
        card.center = view.center
        
        publicKeyLabel.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 20).isActive = true
        publicKeyLabel.rightAnchor.constraint(equalTo: card.rightAnchor, constant: -20).isActive = true
        publicKeyLabel.topAnchor.constraint(equalTo: qrView.bottomAnchor, constant: 20).isActive = true
        publicKeyLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        line0.leftAnchor.constraint(equalTo: card.leftAnchor).isActive = true
        line0.rightAnchor.constraint(equalTo: card.rightAnchor).isActive = true
        line0.bottomAnchor.constraint(equalTo: copyButton.topAnchor).isActive = true
        line0.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        copyButton.leftAnchor.constraint(equalTo: card.leftAnchor).isActive = true
        copyButton.rightAnchor.constraint(equalTo: card.rightAnchor).isActive = true
        copyButton.bottomAnchor.constraint(equalTo: line1.topAnchor).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        line1.leftAnchor.constraint(equalTo: card.leftAnchor).isActive = true
        line1.rightAnchor.constraint(equalTo: card.rightAnchor).isActive = true
        line1.bottomAnchor.constraint(equalTo: doneButton.topAnchor).isActive = true
        line1.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        doneButton.leftAnchor.constraint(equalTo: card.leftAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: card.rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
    }
    
}

