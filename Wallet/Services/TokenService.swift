//
//  TokenService.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import stellarsdk

struct TokenService {
    
    static func getLastPrice(token: Token, completion: @escaping (String) -> Void) {
        let baseAssetType = token.assetType
        let counterAssetType = Token.USD.assetType
        guard let baseAssetCode = token.assetCode,
            let baseAssetIssuer = token.assetIssuer,
            let counterAssetCode = Token.USD.assetCode,
            let counterAssetIssuer = Token.USD.assetIssuer else { return }
        
        Stellar.sdk.trades.getTrades(baseAssetType: baseAssetType,
                                     baseAssetCode: baseAssetCode,
                                     baseAssetIssuer: baseAssetIssuer,
                                     counterAssetType: counterAssetType,
                                     counterAssetCode: counterAssetCode,
                                     counterAssetIssuer: counterAssetIssuer,
                                     offerId: nil,
                                     cursor: nil,
                                     order: Order.descending, limit: 1) { (response) in
                                        switch response {
                                        case .success(let details):
                                            let lastTrade = details.records.first
                                            guard let baseAmount = Decimal(string: lastTrade?.baseAmount ?? "0.0"),
                                                let counterAmount = Decimal(string: lastTrade?.counterAmount ?? "0.0") else { return }
                                            let price = counterAmount/baseAmount
                                            token.lastPrice = price
                                            guard price > 0 else {
                                                DispatchQueue.main.async {
                                                    completion("$0.00")
                                                }
                                                return
                                            }
                                            print("LAST PRICE: \(price)")
                                            DispatchQueue.main.async {
                                                completion(price.currency())
                                            }
                                            break
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        }
        }
        
        
        
    }
    

}

