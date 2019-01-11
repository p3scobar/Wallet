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
import Firebase

extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}



extension Decimal {
    
    func rounded(_ decimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }
    
    func currency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.generatesDecimalNumbers = true
        formatter.groupingSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber) ?? ""
    }
}

extension String {
    func rounded(_ decimals: Int) -> String {
        let decimal = Decimal(string: self) ?? 0
        return decimal.rounded(2)
    }
    
    func currency() -> String {
        let decimal = Decimal(string: self) ?? 0
        return decimal.currency()
    }
}



extension Date {
    
    func medium() -> String {
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


//internal func randomColor(seed: String) -> UIColor {
//    
//    var total: Int = 0
//    for u in seed.unicodeScalars {
//        total += Int(UInt32(u))
//    }
//    
//    srand48(total * 200)
//    let r = CGFloat(drand48())
//    
//    srand48(total)
//    let g = CGFloat(drand48())
//    
//    srand48(total / 200)
//    let b = CGFloat(drand48())
//    
//    return UIColor(red: r, green: g, blue: b, alpha: 1)
//}

internal func randomColor() -> UIColor {
    let red = CGFloat(arc4random_uniform(256))
    let green = CGFloat(arc4random_uniform(256))
    let blue = CGFloat(arc4random_uniform(256))
    print(red)
    print(green)
    print(blue)
    
    return UIColor(red, green, blue)
}



extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}



internal func uploadImageToStorage(image: UIImage, completion: @escaping (String) -> Swift.Void) {
    let imageName = UUID.init().uuidString
    let ref = Storage.storage().reference().child("images").child(imageName)
    guard let jpg = image.jpg else { return }
    ref.putData(jpg, metadata: nil, completion: { (metaData, error) in
        if error != nil {
            print("failed to upload image:", error!)
            return
        }
        ref.downloadURL(completion: { (url, err) in
            if let link = url?.absoluteString {
                completion(link)
            }
        })
    })
}


extension UIImage {
    
    var jpg: Data? {
        return self.jpegData(compressionQuality: 0.8)
    }
    
}
