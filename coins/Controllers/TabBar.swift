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
    
    private var walletVC: WalletController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletVC = WalletController(style: .grouped)
        let wallet = UINavigationController(rootViewController: walletVC)
        wallet.tabBarItem.title = "Wallet"
        wallet.tabBarItem.image = UIImage(named: "home")
        
        let assetsVC = TokensController(style: .grouped)
        let assets = UINavigationController(rootViewController: assetsVC)
        assets.tabBarItem.title = "Assets"
        assets.tabBarItem.image = UIImage(named: "token")
        
        let accountVC = AccountController(style: .grouped)
        let account = UINavigationController(rootViewController: accountVC)
        account.tabBarItem.title = "Account"
        account.tabBarItem.image = UIImage(named: "user")
        
        viewControllers = [wallet, assets, account]
        tabBar.barStyle = .black
        tabBar.barTintColor = Theme.black
        tabBar.tintColor = Theme.highlight
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        if item != items[selectedIndex] {
            
        }
        if item == items[0] {
//            walletVC.scrollToTop()
        }
    }
    
}

