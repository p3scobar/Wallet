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
    
    static var uuid: String {
        get { return UserDefaults.standard.string(forKey: "uuid") ?? "" }
        set (uuid) { UserDefaults.standard.setValue(uuid, forKey: "uuid") }
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
    
    
    init() {}
    
    
    init(_ data: [String:Any]) {
        CurrentUser.uuid = data["uuid"] as? String ?? ""
        CurrentUser.name = data["name"] as? String ?? ""
        CurrentUser.username = data["username"] as? String ?? ""
        CurrentUser.email = data["email"] as? String ?? ""
        CurrentUser.image = data["image"] as? String ?? ""
    }

    
}

