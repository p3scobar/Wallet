//
//  CoinbaseService.swift
//  coins
//
//  Created by Hackr on 12/7/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import Alamofire

struct CoinbaseService {
    
    static func createCheckout(completion: @escaping () -> Void) {
        
        let urlString = "\(coinbaseURL)/checkouts"
        let url = URL(string: urlString)!
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
                                    "X-CC-Version":"2018-03-22"]
        let params: Parameters = ["name":"Gold",
                                  "description":"1 gold oz.",
                                  "pricing_type":"no_price",
                                  "requested_info":["email"]]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            print(response.result.value)
        }
    }
    
    static func listCheckouts(completion: @escaping () -> Void) {
        
        let urlString = "\(coinbaseURL)/checkouts"
        let url = URL(string: urlString)!
        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
                                    "X-CC-Version":"2018-03-22"]
        let params: Parameters = [:]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value)
        }
    }
    
    
    static func createCharge(amount: String, completion: @escaping (String, String) -> Void) {
        
        let urlString = "\(coinbaseURL)/charges"
        let url = URL(string: urlString)!
        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
                                    "X-CC-Version":"2018-03-22"]
        
        let localPrice: Dictionary = [
            "amount": amount,
            "currency": "USD"
        ]
        let params: Parameters = ["name":"Gold",
                                  "description":"1 gold oz.",
                                  "pricing_type":"fixed_price",
                                  "local_price":localPrice]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            guard let value = response.result.value as? [String:Any],
                let data = value["data"] as? [String:Any] else { return }
            guard let addresses = data["addresses"] as? [String:Any],
            let bitcoinAddress = addresses["bitcoin"] as? String else { return }
            print("Bitcoin address: \(bitcoinAddress)")
            
            guard let pricing = data["pricing"] as? [String:Any],
            let bitcoinPrice = pricing["bitcoin"] as? [String:Any],
            let bitcoinAmount = bitcoinPrice["amount"] as? String else { return }
            
            print("Bitcoin amount: \(bitcoinAmount)")
            
            completion(bitcoinAddress, bitcoinAmount)
            let id = data["id"] as? String ?? ""
            let charge = Charge(id: id, amount: bitcoinAmount, address: bitcoinAddress)
            Model.shared.charges.append(charge)
        }
    }
    
    static func getCharge(withID id: String, completion: @escaping () -> Void) {
        
        let urlString = "\(coinbaseURL)/charges/\(id)"
        let url = URL(string: urlString)!
        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
                                    "X-CC-Version":"2018-03-22"]
        let params: Parameters = [:]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value)
        }
    }
    
}


