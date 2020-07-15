//
//  RateManager.swift
//  Wallet
//
//  Created by Hackr on 3/2/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import Foundation
import Alamofire

struct RateManager {
    
//    static var XAUUSD: Double = 5000.0
    
    static var rates: [String:Double] = [
        "XAU": 5000.00,
        "XAG": 120.00
    ]
    
    static func getPrice(assetCode: String, completion: @escaping (Double) -> Void) {
        let urlString = "\(paymentServiceURL)price"
        let url = URL(string: urlString)!
        print("ASSET CODE: \(assetCode)")
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let params: Parameters = ["assetCode":assetCode]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            guard let data = response.result.value as? [String: Any],
                let resp = data["response"] as? [String:Any],
                let priceString = resp["price"] as? NSNumber else {
                    print("Data fetch error on Rate Manager: Price")
                    return
            }
            let price = priceString.doubleValue*1.10
            rates[assetCode] = price
            print("\(assetCode) PRICE: \(price)")
            print(rates)
            completion(price)
        }
    }
    

    static func getMarketPrice(counterAsset: Token, baseAsset: Token) {
        OrderService.bestPrices(buy: counterAsset, sell: baseAsset) { (bestOffer, _) in
//            lastPrice = bestOffer
        }
    }
    
}