//
//  Scan.swift
//  Wallet
//
//  Created by Hackr on 3/21/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation

enum ScanType {
    case publicKey
    case asset
}


struct Scan {
    
    var type: ScanType = .publicKey
    var publicKey: String = ""
    var assetCode: String = ""
    var issuer: String = ""
    
    init(_ code: String) {
        
        let data = code.toDictionary()
        print("DICKTIONARY: \(data)")
        
        if let publicKey = data["publicKey"] as? String {
            type = .publicKey
            self.publicKey = publicKey
        } else if let assetCode = data["assetCode"] as? String,
            let issuer = data["issuer"] as? String {
            type = .asset
            self.assetCode = assetCode
            self.issuer = issuer
        }
        
        
    }
    
    
    
    
}

