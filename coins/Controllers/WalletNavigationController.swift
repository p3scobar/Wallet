//
//  WalletNavigationController.swift
//  coins
//
//  Created by Hackr on 12/8/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import Pulley

class WalletNavigationController: UINavigationController, PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 110
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 360
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

