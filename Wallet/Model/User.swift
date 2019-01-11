//
//  User.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.


import Foundation
import UIKit
import Firebase

class User {
    
    var uuid: String?
    var name: String?
    var username: String?
    var email: String?
    var image: String?
    var publicKey: String?
    
    init() {}
    
    init(_ data: [String:Any]) {
        self.uuid = data["uuid"] as? String
        self.name = data["name"] as? String
        self.username = data["username"] as? String
        self.email = data["email"] as? String
        self.image = data["image"] as? String
        self.publicKey = data["publicKey"] as? String
    }
    
}


