//
//  Theme.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

public struct Theme {}

extension Theme {
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    
    static func semibold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    /// MARK: COLORS
    
    public static var lightGray: UIColor {
        return UIColor(239, 239, 243)
    }
    
    public static var gray: UIColor {
        return UIColor(189, 189, 193)
    }

    public static var black: UIColor {
        return UIColor(30, 30, 30)
    }
    
    public static var green: UIColor {
        return UIColor(0, 183, 48)
    }
    
    

    
}
