//
//  TabBar.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBarController {
    
//    let scan = ScanController()
//    let wallet = WalletController()
//
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let walletVC = HoldingsController(style: .grouped)
//        let wallet = UINavigationController(rootViewController: walletVC)
//        wallet.tabBarItem.image = UIImage(named: "home")
//        wallet.tabBarItem.title = "Wallet"
        
        let orderBookVC = OrderbookController()
        let orderBook = UINavigationController(rootViewController: orderBookVC)
        orderBook.tabBarItem.image = UIImage(named: "token")
        orderBook.tabBarItem.title = "Order Book"
        
        let tokensVC = TokensController()
               let tokens = UINavigationController(rootViewController: tokensVC)
               tokens.tabBarItem.image = UIImage(named: "token")
               tokens.tabBarItem.title = "Currencies"
        
        let accountVC = AccountController(style: .grouped)
        let account = UINavigationController(rootViewController: accountVC)
        account.tabBarItem.image = UIImage(named: "user")
        account.tabBarItem.title = "Account"
        
        viewControllers = [tokens, orderBook, account]
        tabBar.barStyle = .black
        tabBar.barTintColor = Theme.black
        tabBar.tintColor = Theme.highlight
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        if item != items[selectedIndex] {
            
        }
        if item == items[0] {

        }
    }
    
}

