//
//  TokenAboutController.swift
//  coins
//
//  Created by Hackr on 1/7/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class TokenAboutController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let frame = UIScreen.main.bounds
        let view = UIScrollView(frame: frame)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    var about: String
    
    init(description: String) {
        self.about = description
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
        view.backgroundColor = Theme.black
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textView: UITextView = {
        let frame = CGRect(x: 16, y: 20, width: self.view.frame.width-32, height: self.view.frame.height)
        let view = UITextView(frame: frame)
        view.textColor = Theme.highlight
        view.font = Theme.semibold(18)
        view.backgroundColor = Theme.black
        view.isEditable = false
        view.text = about
        return view
    }()
    
}
