//
//  Tools.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk
import AVFoundation

extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


extension Decimal {
    
    func rounded(_ decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }

}


extension Date {
    
    func asString() -> String {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
        return formatter.string(from: self)
    }
    
    func short() -> String {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter
        }()
        return formatter.string(from: self)
    }
    
}


extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
