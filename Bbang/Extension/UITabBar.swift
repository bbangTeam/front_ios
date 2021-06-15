//
//  UITabBar.swift
//  Bbang
//
//  Created by 소영 on 2021/06/16.
//

import UIKit

class UITabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 0.2)

        
    }
    

   

}
