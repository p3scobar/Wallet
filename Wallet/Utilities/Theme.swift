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

//MARK: FONTS

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

    
}

// MARK: COLORS

extension Theme {
    
    public static var lightBackground: UIColor {
        return UIColor(248, 248, 248)
    }

    public static var background: UIColor {
        return UIColor(233, 232, 237)
    }
    
    public static var lightGray: UIColor {
        return UIColor(213, 213, 213)
    }
    
    public static var gray: UIColor {
        return UIColor(107, 107, 107)
    }
    
    public static var darkGray: UIColor {
        return UIColor(60, 60, 60)
    }

    public static var black: UIColor {
        return UIColor(20, 20, 20)
    }
    
    public static var tint: UIColor {
        return UIColor(28, 28, 28)
    }
    
    public static var selected: UIColor {
//        return UIColor(158, 164, 178)
        return UIColor(207, 210, 215)
    }
    
    public static var border: UIColor {
//        return UIColor(64, 64, 66)
        return UIColor(200, 200, 200)
    }
    
    public static var highlight: UIColor {
        return UIColor(255, 198, 92)
    }
    
    public static var white: UIColor {
        return UIColor.white
//        return UIColor(207, 210, 215)
    }
    
//    public static var lightBackground: UIColor {
//        return UIColor(207, 210, 215)
//    }
    
    public static var gold: UIColor {
        return UIColor(228, 203, 172)
    }
    
    public static var card: UIColor {
        return UIColor(32, 32, 32)
    }
    
    public static var button: UIColor {
        return UIColor(80, 80, 80)
    }
    
    
    
    public static var green: UIColor {
        return UIColor(76, 217, 100)
    }
    
    public static var blue: UIColor {
        return UIColor(0, 122, 255)
    }
    
    public static var pink: UIColor {
        return UIColor(255, 45, 85)
    }
    
    public static var purple: UIColor {
        return UIColor(88, 86, 214)
    }
    
    public static var red: UIColor {
        return UIColor(255, 59, 48)
    }
    

    
}
