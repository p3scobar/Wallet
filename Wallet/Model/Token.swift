//
//  Token.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import stellarsdk

public final class Token {
    
    public var balance: String
    public let assetType: String
    public var assetCode: String = "XLM"
    public let assetIssuer: String?
    
    public init(assetType: String, assetCode: String, assetIssuer: String?, balance: String) {
        self.assetType = assetType
        self.assetCode = assetCode
        self.assetIssuer = assetIssuer
        self.balance = balance
    }
    
    public init(assetCode: String, issuer: String) {
        self.assetCode = assetCode
        self.assetIssuer = issuer
        self.balance = "0.0"
        self.assetType = AssetTypeAsString.CREDIT_ALPHANUM4
    }
    
    init(response: AccountBalanceResponse) {
        self.assetType = response.assetType
        self.assetCode = response.assetCode ?? "XLM"
        self.assetIssuer = response.assetIssuer
        self.balance = response.balance
    }
    
    init(_ response: OfferAssetResponse) {
        self.assetType = response.assetType
        self.assetCode = response.assetCode ?? "XLM"
        self.assetIssuer = response.assetIssuer
        self.balance = "0.0"
    }
    
    internal func toRawAsset() -> Asset? {
        var type: Int32
        if assetCode.count >= 5, assetCode.count <= 12 {
            type = AssetType.ASSET_TYPE_CREDIT_ALPHANUM12
        } else if assetCode.count >= 1, assetCode.count <= 4 {
            type = AssetType.ASSET_TYPE_CREDIT_ALPHANUM4
        } else {
            type = AssetType.ASSET_TYPE_NATIVE
        }
        
        if let issuer = self.assetIssuer {
            let issuerKeyPair = try? KeyPair(accountId: issuer)
            return Asset(type: type, code: self.assetCode, issuer: issuerKeyPair)
        }
        
        return Asset(type: type, code: self.assetCode, issuer: nil)
    }
    
    
    public var name: String {
        let code = assetCode ?? ""
        switch code {
        case "XSG":
            return "Supergold"
        case "USD":
            return "US Dollar"
        default:
            return "Stellar Lumens"
        }
    }
    
    public var description: String {
        let code = assetCode ?? ""
        switch code {
        case "HMT":
            return "Hypermetal"
        case "USD":
            return "US Dollar"
        default:
            return ""
        }
    }
    
    public var shortCode: String {
        if assetType == AssetTypeAsString.NATIVE {
            return "XLM"
        } else {
            return assetCode
        }
    }
    
    var lastPrice: Decimal?
    
    public var isNative: Bool {
        if assetType == AssetTypeAsString.NATIVE {
            return true
        }
        
        return false
    }
    
    public var hasZeroBalance: Bool {
        if let balance = Decimal(string: balance) {
            return balance.isZero
        }
        
        return true
    }
}

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.assetType == rhs.assetType && lhs.assetCode == rhs.assetCode && lhs.assetIssuer == rhs.assetIssuer
    }
}


extension Token {
    
    public static var XSG: Token {
        return Token(assetCode: "XSG", issuer: "GAUM73DX3ZHRPFDUCYN5AQIEJ4YYWDBH2RYEW276TWJLSCJSFLB23UWN")
    }
    
    public static var USD: Token {
        return Token(assetCode: "USD", issuer: "GAADWBJDJLXK3VJVGH7WAJV7M755ZENBH4E2HCGIAKU6YH3YYEQBKH3Z")
    }
    
    public static var XLM: Token {
        return Token(assetType: AssetTypeAsString.NATIVE, assetCode: "XLM", assetIssuer: "native", balance: "")
    }
    
    
}

extension Token {
    static var allAssets: [Token] {
        return [Token.USD]
    }
}
