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
    
   
    internal func toRawAsset() -> Asset {
        print(assetCode)
        print(assetType)
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
            return Asset(type: type, code: self.assetCode, issuer: issuerKeyPair)!
        }
        
        return Asset(type: type, code: self.assetCode, issuer: nil) ?? Asset(type: AssetType.ASSET_TYPE_NATIVE)!
    }
    
    
    public var name: String {
        let code = assetCode
        switch code {
        case "DMT":
            return "Delemont"
        case "XAU":
            return "Gold"
        case "XAG":
            return "Silver"
        case "XLM":
            return "Stellar Lumens"
        case "USD":
            return "US Dollars"
        default:
            return ""
        }
    }
    
    public var description: String {
        let code = assetCode
        switch code {
        case "DMT":
            return "Delemont Trust Shares"
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
    
    public static var XAG: Token {
        return Token(assetCode: "XAG", issuer: "GAJS6UJ2I6TREFZVMAVNL7COQ4EJK4GUZGPNAS2J2HHVCOT7TBKHAXCI")
    }
    
    public static var XAU: Token {
        return Token(assetCode: "XAU", issuer: "GAJS6UJ2I6TREFZVMAVNL7COQ4EJK4GUZGPNAS2J2HHVCOT7TBKHAXCI")
    }
    
    public static var DMT: Token {
        return Token(assetCode: "DMT", issuer: "GAJS6UJ2I6TREFZVMAVNL7COQ4EJK4GUZGPNAS2J2HHVCOT7TBKHAXCI")
    }
    
    public static var USD: Token {
        return Token(assetCode: "USD", issuer: "GAJS6UJ2I6TREFZVMAVNL7COQ4EJK4GUZGPNAS2J2HHVCOT7TBKHAXCI")
    }
    
    public static var native: Token {
        return Token(assetType: AssetTypeAsString.NATIVE, assetCode: "XLM", assetIssuer: nil, balance: "")
    }
    
}
