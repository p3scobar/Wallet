//
//  InputCurrencyCell.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class InputCurrencyCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: InputNumberCellDelegate?
    var key = 0
    var value: Decimal = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .white
        selectionStyle = .none
        valueInput.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        valueInput.text = value.currency()
        formatInput()
    }
    
    @objc func editingChanged() {
        formatInput()
        delegate?.textFieldDidChange(key: key, value: value)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func formatInput() {
        guard valueInput.decimal <= valueInput.maximum else {
            valueInput.text = valueInput.lastValue
            return
        }
        valueInput.lastValue = Formatter.currency.string(for: valueInput.decimal) ?? ""
        valueInput.text = valueInput.lastValue
        value = valueInput.decimal
    }
    
    lazy var valueInput: CurrencyField = {
        let label = CurrencyField()
        label.font = Theme.medium(20)
        label.textColor = Theme.black
        label.tintColor = Theme.highlight
        if label.placeholder != nil {
            label.attributedPlaceholder = NSAttributedString(string: label.placeholder!, attributes: [NSAttributedString.Key.foregroundColor:Theme.gray])
        }
        label.textAlignment = .right
        label.keyboardType = .decimalPad
        label.keyboardAppearance = .light
        label.placeholder = "$0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupView() {
        backgroundColor = Theme.white
        textLabel?.textColor = Theme.gray
        textLabel?.font = Theme.medium(20)
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


