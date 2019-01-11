//
//  Button.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class Button: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = Theme.selected
            } else {
                backgroundColor = previousTintColor
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                backgroundColor = Theme.tint
            }
        }
    }
    
    
    private var previousTintColor: UIColor?
    
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        setTitle(title, for: .normal)
        titleLabel?.font = Theme.semibold(20)
        layer.cornerRadius = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        previousTintColor = self.backgroundColor
        isHighlighted = true
        sendActions(for: .touchDown)
    }
    
    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = false
    }
    
    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = false
        sendActions(for: .touchUpInside)
    }
    
}

