//
//  TransferService.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Firebase
import Foundation
import Alamofire

public struct TransferService {
//
//    static var transfers: [Transfer] = []
//
//    static func createCheckout(completion: @escaping () -> Void) {
//
//        let urlString = "\(coinbaseURL)/checkouts"
//        let url = URL(string: urlString)!
//        let headers: HTTPHeaders = ["Content-Type":"application/json",
//                                    "X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
//                                    "X-CC-Version":"2018-03-22"]
//        let params: Parameters = ["name":"Gold",
//                                  "description":"1 gold oz.",
//                                  "pricing_type":"no_price",
//                                  "requested_info":["email"]]
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (response) in
//            print(response.result.value)
//        }
//    }
//
//    static func listCheckouts(completion: @escaping () -> Void) {
//
//        let urlString = "\(coinbaseURL)/checkouts"
//        let url = URL(string: urlString)!
//        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
//                                    "X-CC-Version":"2018-03-22"]
//        let params: Parameters = [:]
//        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//            print(response.result.value)
//        }
//    }
//
//
//    static func createOrder(size: String, price: String, total: String, completion: @escaping (Transfer) -> Void) {
//        let currency: String = "USD"
//
//        let urlString = "\(coinbaseURL)/charges"
//        let url = URL(string: urlString)!
//        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
//                                    "X-CC-Version":"2018-03-22"]
//
//        let localPrice: Dictionary = [
//            "amount": total,
//            "currency": currency
//        ]
//
//        let params: Parameters = ["currency": localPrice,
//                                  "name":"Testing",
//                                  "description":"Some test description",
//                                  "pricing_type":"fixed_price",
//                                  "local_price":localPrice]
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//            print(response)
//            guard let value = response.result.value as? [String:Any],
//                let data = value["data"] as? [String:Any] else { return }
//            guard let addresses = data["addresses"] as? [String:Any],
//                let bitcoinAddress = addresses["bitcoin"] as? String else { return }
//            print("Bitcoin address: \(bitcoinAddress)")
//
//            guard let pricing = data["pricing"] as? [String:Any],
//                let bitcoin = pricing["bitcoin"] as? [String:Any],
//                let amountBitcoin = bitcoin["amount"] as? String,
//                let BTC = bitcoin["currency"] as? String else { return }
//
//            guard let local = pricing["local"] as? [String:Any],
//            let amountUSD = local["amount"] as? String,
//            let USD = local["currency"] as? String else { return }
//            print("Bitcoin amount: \(amountBitcoin)")
//
//            let id = data["id"] as? String ?? ""
//            let transfer = Transfer(id: id,
//                                    type: .deposit,
//                                    currency: BTC,
//                                    amount: amountBitcoin,
//                                    bitcoinAddress: bitcoinAddress,
//                                    price: price)
//            completion(transfer)
//            saveDepositToDatabase(transfer: transfer, currency: currency)
//            self.transfers.insert(transfer, at: 0)
//        }
//    }
//
//
//    static func createWithdrawal(amount: String, completion: @escaping (Transfer) -> Void) {
//
//        let currency: String = "GOLD"
//        let id = UUID().uuidString
//        let address = KeychainHelper.publicKey
//
//        let values: [String:Any] = ["id":id,
//                                    "currency":currency,
//                                    "address":address,
//                                    "amount":amount,
//                                    "status":"pending",
//                                    "type":"withdrawal"]
//
//        let ref = db.collection("Users").document(address).collection("transfers").document(id)
//        ref.setData(values, merge: true)
////        let transfer = Transfer(id: id,
////                                type: .deposit, currency: currency, amount: amount, address: address, price: price)
////        self.transfers.insert(transfer, at: 0)
////        completion(transfer)
//    }
//
//    internal static func saveDepositToDatabase(transfer: Transfer, currency: String) {
//
//        let id = transfer.id
//        let timestamp = transfer.timestamp
//        let amount = transfer.amount
//        let address = transfer.bitcoinAddress
//        let publicKey = KeychainHelper.publicKey
//        let ref = db.collection("Users").document(publicKey).collection("transfers")
//
//        let values: [String:Any] = ["id":id,
//                                    "timestamp": timestamp,
//                                    "amount": amount,
//                                    "address": address,
//                                    "source": "coinbase",
//                                    "currency": "BTC",
//                                    "status":"pending",
//                                    "type":"deposit"]
//
//        ref.addDocument(data: values)
//    }
//
//    //    static func getCharges(completion: @escaping ([Charge]) -> Void) {
//
//    //        let urlString = "\(coinbaseURL)/charges/"
//    //        let url = URL(string: urlString)!
//    //        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
//    //                                    "X-CC-Version":"2018-03-22"]
//    //        let params: Parameters = [:]
//    //        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//    //print(response.result.value)
//    //            guard let value = response.result.value as? [String:Any],
//    //                let data = value["data"] as? [String:Any] else { return }
//    //            print(data)
//    //        }
//
//    static func getChargesFromDatabase(completion: @escaping ([Transfer]) -> Void) {
//        let publicKey = KeychainHelper.publicKey
//        var charges: [Transfer] = []
//        let ref = db.collection("Users").document(publicKey).collection("transfers")
//        ref.getDocuments { (snap, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                snap?.documents.forEach({ (doc) in
//                    let charge = Transfer(data: doc.data())
//                    charges.append(charge)
//                })
//                let sorted = charges.sorted(by: { $0.timestamp > $1.timestamp })
//                completion(sorted)
//            }
//        }
//    }
//
//
//
//    static func getCharge(withID id: String, completion: @escaping (String) -> Void) {
//
//        let urlString = "\(coinbaseURL)/charges/M69HWAE3"
//        let url = URL(string: urlString)!
//        let headers: HTTPHeaders = ["X-CC-Api-Key": "39ecf71b-1f46-475a-98fd-56a15b79d301",
//                                    "X-CC-Version":"2018-03-22"]
//        let params: Parameters = [:]
//        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//            //print(response.result.value)
//            guard let value = response.result.value as? [String:Any],
//                let data = value["data"] as? [String:Any] else { return }
//            guard let timeline = data["timeline"] as? [[String:Any]] else { return }
//            if let last = timeline.last,
//                let status = last["status"] as? String {
//                completion(status)
//            }
//            
//        }
//    }
//
//
//
    
}

