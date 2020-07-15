//
//  PaymentService.swift
//  Wallet
//
//  Created by Hackr on 3/23/20.
//  Copyright © 2020 Sugar. All rights reserved.
//


import Foundation
import Alamofire
import Stripe



class PaymentService: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let urlString = "\(paymentServiceURL)/ephemeralKey"
        let url = URL(string: urlString)!
        let token = CurrentUser.token
        let headers: HTTPHeaders = ["Authorization":"Bearer \(token)"]
        let params: Parameters = [:]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            print(response)
            guard let data = response.result.value as? [String:Any] else {
                print("ERROR ON EPHEMERAL KEY FETCH")
                return
            }
            completion(data, nil)
        }
      }
    
    
    static func paymentIntent(size: Double, paymentMethodID: String, completion: @escaping (_ secret: String?) -> Void) {
        let publicKey = KeychainHelper.publicKey
        let urlString = "\(paymentServiceURL)paymentintent"
        let url = URL(string: urlString)!
        let token = CurrentUser.token
        let headers: HTTPHeaders = ["Content-Type":"application/json", "Authorization": "Bearer \(token)"]
        let params: Parameters = ["size": size,
                                  "publicKey": publicKey,
                                  "paymentMethodID": paymentMethodID]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            
            guard let data = response.result.value as? [String: Any],
                let resp = data["response"] as? [String:Any],
                let clientSecret = resp["clientSecret"] as? String else {
                    print("Data fetch error on Payment Intent")
                    completion(nil)
                    return
            }
            completion(clientSecret)
        }
    }
    
    
    static func getOrders(completion: @escaping ([Trade]) -> Void) {
        let urlString = "\(paymentServiceURL)orders"
        let url = URL(string: urlString)!
        let token = CurrentUser.token
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Authorization": "Bearer \(token)"]
        let params: Parameters = [:]
        var transactions: [Trade] = []
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            print(response)
            guard let value = response.result.value as? [String: Any],
                let resp = value["response"] as? [String:Any],
                let orders = resp["orders"] as? [[String:Any]] else {
                    print("Data fetch error on Get Orders")
                    return
            }
            print(resp)
            orders.forEach { (data) in
                
                let id = data["_id"] as? String ?? ""
                let timestamp = data["Created Date"] as? Date ?? Date()
                let assetCode = data["assetCode"] as? String ?? ""
                let status = data["status"] as? String ?? ""
                let type = data["type"] as? String ?? ""
                let sizeNumber = data["size"] as? Double ?? 0.0
                let size = "\(sizeNumber)"
                let priceNumber = data["price"] as? Double ?? 0.0
                let price = "\(priceNumber)"
                let subtotalNumber = data["subtotal"] as? Double ?? 0.0
                let subtotal = "\(subtotalNumber)"
                let feeNumber = data["fee"] as? Double ?? 0.0
                let fee = "\(feeNumber)"
                let totalNumber = data["total"] as? Double ?? 0.0
                let total = "\(totalNumber)"
                let side = data["side"] as? String ?? "buy"
                
                let transaction = Trade.findOrCreateTrade(id: id,
                                                          status: status,
                                                          timestamp: timestamp,
                                                          size: size,
                                                          price: price,
                                                          subtotal: subtotal,
                                                          fee: fee,
                                                          total: total,
                                                          side: side,
                                                          baseAssetCode: "USD",
                                                          baseAccount: "",
                                                          baseAmount: total,
                                                          counterAssetCode: assetCode,
                                                          counterAccount: "",
                                                          counterAmount: size,
                                                          in: PersistenceService.context)
                transactions.append(transaction)
            }
            completion(transactions)
        }
    }
    
    
    static func getCards(completion: @escaping ([PaymentMethod]) -> Void) {
        
        let urlString = "\(paymentServiceURL)/paymentMethods"
        let url = URL(string: urlString)!
        let token = CurrentUser.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = [:]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            print("ID: \(CurrentUser.id)")
            print("CARD RESPONSE: \(response)")
            guard let data = response.result.value as? [String:Any],
                let resp = data["response"] as? [String:Any] else {
                    return
            }
            
            guard let cardsData = resp["cards"] as? [[String:Any]] else {
                print("Failed to parse card data")
                return
            }
            print("CARD DATA: \(cardsData)")
            var methods: [PaymentMethod] = []
            cardsData.forEach { (cardData) in
                let id = cardData["_api_c2_id"] as? String ?? ""
                let brand = cardData["_api_c2_card.brand"] as? String ?? ""
                let last4 = cardData["_api_c2_card.last4"] as? String ?? ""
                let card = PaymentMethod(id: id, type: .card, brand: brand, last4: last4)
                methods.append(card)
                cards[id] = card
            }
            if let firstCard = cards.first?.value {
                defaultPaymentMethod = firstCard
            }
            completion(methods)
        }
    }
    
    
    
    static func subscribe(assetCode: String, amount: Double, paymentMethodID: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(paymentServiceURL)/subscribe"
        let url = URL(string: urlString)!
        let token = CurrentUser.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = ["assetCode":assetCode, "amount":amount, "paymentMethod": paymentMethodID]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
            print(response.result.value)
            guard let data = response.result.value as? [String:Any],
                let resp = data["response"] as? [String:Any],
                let planData = resp["plan"] as? [String:Any] else {
                    completion(false)
                return
            }
            let id = planData["_id"] as? String ?? ""
            let assetCode = planData["assetCode"] as? String ?? ""
            let amount = planData["amount"] as? Double ?? 0.0
            let isActive = planData["isActive"] as? Bool ?? false
            let plan = Plan(id: id, assetCode: assetCode, amount: amount, isActive: isActive)
            plans[assetCode] = plan
            completion(true)
        }
    }
    
    static func getPlan() {
            let urlString = "\(paymentServiceURL)/plans"
            let url = URL(string: urlString)!
            let token = CurrentUser.token
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
                guard let data = response.result.value as? [String:Any],
                    let resp = data["response"] as? [String:Any],
                    let plansData = resp["plans"] as? [[String:Any]] else {
                    return
                }
                
                plansData.forEach { (planData) in
                    let id = planData["_id"] as? String ?? ""
                    let assetCode = planData["assetCode"] as? String ?? ""
                    let amount = planData["amount"] as? Double ?? 0.0
                    let isActive = planData["isActive"] as? Bool ?? false
                    let plan = Plan(id: id, assetCode: assetCode, amount: amount, isActive: isActive)
                    plans[assetCode] = plan
                }
            }
        }
    
}
      
