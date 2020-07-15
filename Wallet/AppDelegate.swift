//
//  AppDelegate.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Pulley
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Stripe.setDefaultPublishableKey(stripePk)
//        STPPaymentConfiguration.shared().appleMerchantIdentifier = merchantID
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = Theme.black
        UINavigationBar.appearance().backgroundColor = Theme.black
        UINavigationBar.appearance().tintColor = Theme.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().prefersLargeTitles = true
        
        UITableView.appearance().separatorColor = Theme.border
        
        let vc = TokensController(style: .grouped)
        let nav = UINavigationController(rootViewController: vc)
        
        RateManager.getMarketPrice(counterAsset: counterAsset, baseAsset: baseAsset)
        window?.rootViewController = nav
        window?.layer.cornerRadius = 12

        if #available(iOS 13.0, *) {
            let statusBar1 =  UIView()
            statusBar1.frame = UIApplication.shared.statusBarFrame
            statusBar1.backgroundColor = Theme.background
            UIApplication.shared.keyWindow?.addSubview(statusBar1)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        WalletService.streamItem?.closeStream()
        PersistenceService.saveContext()
    }
    
}

