//
//  User.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    static var shared: User = User()
    
    var uuid: String {
        get { return UserDefaults.standard.string(forKey: "uuid") ?? "" }
        set (uuid) { UserDefaults.standard.setValue(uuid, forKey: "uuid") }
    }
    
    var name: String {
        get { return UserDefaults.standard.string(forKey: "name") ?? "" }
        set (name) { UserDefaults.standard.setValue(name, forKey: "name") }
    }
    
    var username: String {
        get { return UserDefaults.standard.string(forKey: "username") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "username") }
    }
    
    var email: String {
        get { return UserDefaults.standard.string(forKey: "email") ?? "" }
        set (email) { UserDefaults.standard.setValue(email, forKey: "email") }
    }
    
    var soundsEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: "soundEnabled") }
        set (enabled) { UserDefaults.standard.set(enabled, forKey: "soundEnabled") }
    }
    
    init() {}
    
}


