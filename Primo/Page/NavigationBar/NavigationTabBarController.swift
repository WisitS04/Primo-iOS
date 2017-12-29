//
//  NavigationTabBarController.swift
//  Primo
//
//  Created by spoton on 25/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class NavigationTabBarController: UIViewController{
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         let placeViewController  = PlaceViewController()
         placeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        let viewControllerList = [placeViewController]
        
    }
}
