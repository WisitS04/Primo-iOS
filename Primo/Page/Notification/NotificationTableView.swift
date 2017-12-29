//
//  NotificationTableViewController.swift
//  Primo
//
//  Created by spoton on 26/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Mixpanel

class NotificationTableView: UITableView {
 
    var viewController: NotificationViewController!
    var NotificationData:[notificationModel] = []
    
    func SetUp(viewController: NotificationViewController) {
        self.viewController = viewController
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50.0
        getDataDB()
    }
    
}

extension NotificationTableView {
    func getDataDB()  {
        self.NotificationData = NotificationDB.instance.getNotification()
        self.reloadData()
    }
    
}

extension NotificationTableView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.NotificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath) as! NotificationTableCell
        
        cell.image_logo.image = UIImage(named: "addcard_sidemenu")
        cell.txt_title.text = NotificationData[indexPath.row].titleName
        cell.txt_subtitle.text = NotificationData[indexPath.row].subTitleName
        cell.image_arrow.image = UIImage(named: "contact_sidemenu")
        
        return cell
    }
    
    
    
}
