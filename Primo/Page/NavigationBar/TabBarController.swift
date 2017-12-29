//
//  TabBarController.swift
//  Primo
//
//  Created by spoton on 25/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import Foundation
import UIKit


class TabBarController: UITabBarController, UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeViewController  = PlaceViewController()
        let homeNavigationcontroller = UINavigationController(rootViewController: placeViewController)
        homeNavigationcontroller.title = "หน้าหลัก"
        homeNavigationcontroller.tabBarItem.image = UIImage(named: "addcard_sidemenu")
        
        let search = UIViewController()
        let searchNavigationController = UINavigationController(rootViewController: search)
        searchNavigationController.title = "ค้นหา"
        searchNavigationController.tabBarItem.image = UIImage(named: "addcard_sidemenu")
        
        
        let summary = UIViewController()
        let summaryNavigationController = UINavigationController(rootViewController: summary)
        summaryNavigationController.title = "ส่วนลดรวม"
        summaryNavigationController.tabBarItem.image = UIImage(named: "addcard_sidemenu")
        
        
        let notification = UIViewController()
        let notificationNavigationController = UINavigationController(rootViewController: notification)
        notificationNavigationController.title = "แจ้งเตือน"
        notificationNavigationController.tabBarItem.image = UIImage(named: "addcard_sidemenu")
        
        
        let profile = UIViewController()
        let profileNavigationController = UINavigationController(rootViewController: profile)
        profileNavigationController.title = "โปรไฟล์"
        profileNavigationController.tabBarItem.image = UIImage(named: "addcard_sidemenu")
        
        
        
        viewControllers = [homeNavigationcontroller]
    }
}
