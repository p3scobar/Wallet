//
//  TabBar.swift
//  coins
//
//  Created by Hackr on 1/1/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Pulley

class TabBar: UITabBarController {
    
    let scan = ScanController()
    let wallet = WalletController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let walletNav = WalletNavigationController(rootViewController: wallet)
        
        let pulley = PulleyViewController(contentViewController: scan, drawerViewController: walletNav)
        
        pulley.tabBarItem.image = UIImage(named: "home")
        pulley.initialDrawerPosition = .open
        pulley.drawerCornerRadius = 32
        
        let accountVC = AccountController(style: .grouped)
        let account = UINavigationController(rootViewController: accountVC)
        account.tabBarItem.image = UIImage(named: "user")
        
        viewControllers = [pulley, account]
        tabBar.barStyle = .default
        tabBar.barTintColor = Theme.white
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

