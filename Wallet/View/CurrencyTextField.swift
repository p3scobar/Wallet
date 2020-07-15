//
//  CurrencyTextField.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class CurrencyField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(paddingView)
    }
    
    lazy var paddingView: UIView = {
        let frame = CGRect(x: 0, y: 8, width: self.frame.width, height: self.frame.height-16)
        let view = UIView(frame: frame)
        view.backgroundColor = Theme.black
        return view
    }()
    
//    (frame: CGRectMake(0, 0, 15, self.te.frame.height))
//          myTextField.leftView = paddingView
//          myTextField.leftViewMode = UITextFieldViewMode.Always
//
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue }
    let maximum: Decimal = 999_999_999_999.99
    var lastValue: String = ""
    
}

extension String {
    var digits: [UInt8] { return compactMap{ UInt8(String($0)) } }
}


extension Collection where Iterator.Element == UInt8 {
    var string: String { return map(String.init).joined() }
    var decimal: Decimal { return Decimal(string: string) ?? 0 }
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}

extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}

extension Decimal {
    var number: NSDecimalNumber {
        return NSDecimalNumber(decimal: self)
    }
    
}

