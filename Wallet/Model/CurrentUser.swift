//
//  CurrentUser.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CurrentUser {
    
    static var id: String {
        get { return UserDefaults.standard.string(forKey: "id") ?? "" }
        set (id) { UserDefaults.standard.setValue(id, forKey: "id") }
    }
    
    static var name: String {
        get { return UserDefaults.standard.string(forKey: "name") ?? "" }
        set (name) { UserDefaults.standard.setValue(name, forKey: "name") }
    }
    
    static var username: String {
        get { return UserDefaults.standard.string(forKey: "username") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "username") }
    }
    
    static var email: String {
        get { return UserDefaults.standard.string(forKey: "email") ?? "" }
        set (email) { UserDefaults.standard.setValue(email, forKey: "email") }
    }
    
    static var soundsEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: "soundEnabled") }
        set (enabled) { UserDefaults.standard.set(enabled, forKey: "soundEnabled") }
    }
    
    static var image: String {
        get { return UserDefaults.standard.string(forKey: "image") ?? "" }
        set (url) { UserDefaults.standard.set(url, forKey: "image") }
    }
    
    static var stripeID: String {
        get { return UserDefaults.standard.string(forKey: "stripeId") ?? "" }
        set (stripeId) { UserDefaults.standard.set(stripeId, forKey: "stripeId") }
    }
    
    static var token: String {
        get { return UserDefaults.standard.string(forKey: "token") ?? "" }
        set (token) { UserDefaults.standard.set(token, forKey: "token") }
    }
    
    init() {}
    
    init(_ data: [String:Any]) {
        CurrentUser.id = data["id"] as? String ?? ""
        CurrentUser.name = data["name"] as? String ?? ""
        CurrentUser.username = data["username"] as? String ?? ""
        CurrentUser.email = data["email"] as? String ?? ""
        CurrentUser.image = data["image"] as? String ?? ""
        CurrentUser.token = data["token"] as? String ?? ""
    }

    
}

