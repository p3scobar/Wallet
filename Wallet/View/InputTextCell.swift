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
    var placeholder: String? {
        didSet {
            valueInput.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
        backgroundColor = Theme.tint
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
        label.font = Theme.medium(16)
        label.textColor = Theme.white
        label.tintColor = Theme.highlight
        label.textAlignment = .right
        label.keyboardType = .default
        label.keyboardAppearance = .default
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupView() {
        backgroundColor = Theme.black
        textLabel?.textColor = Theme.lightGray
        textLabel?.font = Theme.medium(16)
        addSubview(valueInput)
        
        valueInput.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        valueInput.topAnchor.constraint(equalTo: topAnchor).isActive = true
        valueInput.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        valueInput.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


