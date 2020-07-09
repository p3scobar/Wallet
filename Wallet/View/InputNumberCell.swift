//
//  InputNumberCell.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

protocol InputNumberCellDelegate: class {
    func textFieldDidChange(key: Int, value: Double)
}

class InputNumberCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: InputNumberCellDelegate?
    var key = 0
    var value: Double = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = Theme.tint
        selectionStyle = .none
        valueInput.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        guard let text = valueInput.text else { return }
        let decimal = Double(text) ?? 0.0
        value = decimal
        delegate?.textFieldDidChange(key: key, value: decimal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    let valueInput: UITextField = {
        let label = UITextField()
        label.font = Theme.semibold(18)
        label.textColor = Theme.white
        label.tintColor = Theme.highlight
        label.attributedPlaceholder = NSAttributedString(string: label.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
        label.textAlignment = .right
        label.keyboardType = .decimalPad
        label.keyboardAppearance = .dark
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupView() {
        backgroundColor = Theme.black
        textLabel?.textColor = Theme.lightGray
        textLabel?.font = Theme.semibold(18)
        addSubview(valueInput)
        
        valueInput.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        valueInput.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueInput.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        valueInput.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


