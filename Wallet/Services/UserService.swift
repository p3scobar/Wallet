//
//  UserService.swift
//  Wallet
//
//  Created by Hackr on 1/8/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Firebase
import Foundation

public struct UserService {
    
    static func checkIfUsernameAvailable(_ username: String, completion: @escaping (Bool) -> Void) {
        let ref = db.collection("users").whereField("username", isEqualTo: username)
        ref.getDocuments { (snap, err) in
            if err != nil {
                completion(false)
            }
            if snap?.documents.count ?? 0 > 0 {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func setUsername(publicKey: String, username: String, completion: @escaping (Bool) -> Void) {
        let data = ["username":username,
                    "publicKey":publicKey]
        db.collection("users").document(publicKey).setData(data, merge: true) { (err) in
            if let error = err {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    static func setUserData(_ data: [String:Any]) {
        let publicKey = KeychainHelper.publicKey
        db.collection("users").document(publicKey).setData(data, merge: true) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getUserFor(username: String, completion: @escaping (User) -> Void) {
        let ref = db.collection("users").whereField("username", isEqualTo: username)
        ref.getDocuments { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                guard let data = snap?.documents.first?.data() else { return }
                let user = User(data)
                completion(user)
            }
        }
    }
    
    static func getUserFor(publicKey: String, completion: @escaping (User) -> Void) {
        let ref = db.collection("users").whereField("publicKey", isEqualTo: publicKey)
        ref.getDocuments { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                guard let data = snap?.documents.first?.data() else { return }
                let user = User(data)
                completion(user)
            }
        }
    }
    
    
    static func setFavorite(_ username: String, completion: @escaping (Bool) -> Void) {
        let publicKey = KeychainHelper.publicKey
        let userRef = db.collection("users").document(publicKey)
        userRef.updateData([
            "favorites": FieldValue.arrayUnion([username])
        ]) { (err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                completion(true)
            }
        }
    }
    
    static func deleteFavorite(publicKey: String, username: String, completion: @escaping (Bool) -> Void) {
        let userRef = db.collection("users").document(publicKey)
        userRef.updateData([
            "favorites": FieldValue.arrayRemove([username])
        ]) { (err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                completion(true)
            }
        }
    }
    
    
    static func getFavorites(completion: @escaping ([User]) -> Void) {
        let publicKey = KeychainHelper.publicKey
        let dispatchGroup = DispatchGroup()
        db.collection("users").document(publicKey).getDocument { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                var contacts: [User] = []
                guard let data = snap?.data(),
                let favorites = data["favorites"] as? [String] else { return }
                dispatchGroup.wait()
                favorites.forEach({ (username) in
                    dispatchGroup.enter()
                    fetchUserForUsername(username, completion: { (user) in
                        contacts.append(user)
                        dispatchGroup.leave()
                    })
                })
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    completion(contacts)
                }
            }
        }
    }
    
    fileprivate static func fetchUserForUsername(_ username: String, completion: @escaping (User) -> Void) {
        let ref = db.collection("users").whereField("username", isEqualTo: username)
        ref.getDocuments { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                guard let data = snap?.documents.first?.data() else { return }
                let user = User(data)
                completion(user)
            }
        }
        
    }
    
    
    static func updateProfilePic(image: UIImage, completion: @escaping (String) -> Void) {
        uploadImageToStorage(image: image) { (imageUrl) in
            let publicKey = KeychainHelper.publicKey
            let data = ["image":imageUrl]
            db.collection("users").document(publicKey).setData(data, merge: true, completion: { (err) in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    
                    CurrentUser.image = imageUrl
                    completion("")
                }
            })
        }
    }
    
    
    static func getCurrentUser() {
        let publicKey = KeychainHelper.publicKey
        db.collection("users").document(publicKey).getDocument { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                guard let data = snap?.data() else { return }
                let _ = CurrentUser(data)
            }
        }
    }
    
}
