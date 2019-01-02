//
//  InputTextCell.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

protocol InputTextCellDelegate: class {
    func textFieldDidChange(key: Int, value: String)
}

class InputTextCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: InputTextCellDelegate?
    var key = 0
    var value: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
        valueInput.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        guard let text = valueInput.text else { return }
        self.value = text
        delegate?.textFieldDidChange(key: key, value: text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    lazy var valueInput: UITextField = {
        let label = UITextField()
        label.font = Theme.medium(18)
        label.textColor = .white
        label.tintColor = Theme.highlight
        label.attributedPlaceholder = NSAttributedString(string: label.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
        label.textAlignment = .right
        label.keyboardType = .default
        label.keyboardAppearance = .default
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupView() {
        backgroundColor = Theme.tint
        textLabel?.textColor = Theme.gray
        textLabel?.font = Theme.medium(18)
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


