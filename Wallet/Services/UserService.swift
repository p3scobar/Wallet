//
//  UserService.swift
//  Wallet
//
//  Created by Hackr on 1/8/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Firebase
import Foundation
import Alamofire

public struct UserService {
    
    static func signup(_ email: String, _ password: String, _ name: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(dbURL)/signup"
            let url = URL(string: urlString)!
            let params: [String:Any] = ["email":email,
                                        "password":password,
                                        "name":name]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                print(response)
                
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let uid = resp["user_id"] as? String else {
                        completion(false)
                        return
                }
                let user = resp["user"] as? [String:Any] ?? [:]
                let stripeId = user["stripeId"] as? String ?? ""
                print("SIGNUP RESPONSE: \(resp)")
                let token = resp["token"] as? String ?? ""
                CurrentUser.token = token
                CurrentUser.id = uid
                CurrentUser.email = email
                CurrentUser.name = name
                CurrentUser.stripeID = stripeId
                completion(true)
            }
        }
    }
    
    static func login(_ email: String, _ password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(dbURL)/login"
            let url = URL(string: urlString)!
            let params: [String:Any] = ["email":email,
                                        "password":password]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                print(response)
                
                guard let json = response.result.value as? [String:Any],
                    let resp = json["response"] as? [String:Any],
                    let uid = resp["user_id"] as? String else {
                        completion(false)
                        return
                }
                let user = resp["user"] as? [String:Any] ?? [:]
                let stripeId = user["stripeId"] as? String ?? ""
                let token = resp["token"] as? String ?? ""
                CurrentUser.token = token
                CurrentUser.id = uid
                CurrentUser.email = email
                CurrentUser.stripeID = stripeId
                completion(true)
            }
        }
    }
    
    static func updateUsername(_ username: String, completion: @escaping (Bool) -> Void) {
        let urlString = "\(dbURL)/username"
        let url = URL(string: urlString)!
        let token = CurrentUser.token
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: [String:Any] = ["username":username]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            guard let json = response.result.value as? [String:Any],
                let resp = json["response"] as? [String:Any],
                let username = resp["username"] as? String else {
                    completion(false)
                    return
            }
            CurrentUser.username = username
            completion(true)
        }
    }
    
    static func signout(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let urlString = "\(dbURL)/signout"
            let url = URL(string: urlString)!
            let params: [String:Any] = [:]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                CurrentUser.id = ""
                CurrentUser.name = ""
                CurrentUser.username = ""
                CurrentUser.email = ""
                CurrentUser.image = ""
                CurrentUser.token = ""
                CurrentUser.stripeID = ""
                WalletService.signOut {}
                completion(true)
            }
        }
    }
        
        
}
