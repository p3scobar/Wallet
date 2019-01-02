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

    public static var lightbackground: UIColor {
        return UIColor(218, 218, 218)
    }
    
    public static var lightGray: UIColor {
        return UIColor(213, 213, 213)
    }
    
    public static var gray: UIColor {
        return UIColor(100, 100, 100)
    }

    public static var black: UIColor {
        return UIColor(18, 18, 18)
    }
    
    public static var tint: UIColor {
        return UIColor(30, 30, 30)
    }
    
    public static var selected: UIColor {
        return UIColor(48, 48, 48)
    }
    
    public static var border: UIColor {
        return UIColor(64, 64, 66)
    }
    
    public static var highlight: UIColor {
//        return UIColor(244, 134, 31)
        return UIColor(22, 228, 172)
    }
    
    public static var white: UIColor {
        return UIColor(255, 255, 255)
    }
    
    public static var button: UIColor {
        return UIColor(80, 80, 80)
    }
    
    public static var green: UIColor {
        return UIColor(0, 183, 48)
    }
    
    

    
}
