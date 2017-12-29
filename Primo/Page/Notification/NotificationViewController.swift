//
//  NotificationViewController.swift
//  Primo
//
//  Created by spoton on 26/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var NotificationTableView: NotificationTableView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        NotificationTableView.contentInset = UIEdgeInsets.zero
//        self.automaticallyAdjustsScrollViewInsets = false
//
//        NotificationTableView.SetUp(viewController: self)
////        NotificationTableView.getDataDB()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationTableView.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationTableView.SetUp(viewController: self)
        self.NotificationTableView.reloadData()
        
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Deleate", style: .plain, target: self, action: #selector(Delate))
        
    }
    
    @objc func Delate(_ sender: Any)  {
        _ = NotificationDB.instance.deleteNotification()
        NotificationTableView.SetUp(viewController: self)
    }
}
