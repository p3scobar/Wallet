//
//  Model.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Model {
    
    var transfers = [Transfer]()
    
    static let shared: Model = Model()
    
    var uuid: String {
        get { return UserDefaults.standard.string(forKey: "userId") ?? "" }
        set (uid) { UserDefaults.standard.setValue(uid, forKey: "userId") }
    }
   
    
    var soundsEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: "soundEnabled") }
        set (enabled) { UserDefaults.standard.set(enabled, forKey: "soundEnabled") }
    }
    
    init() {}
    
}

