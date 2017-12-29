//
//  Search.swift
//  Primo
//
//  Created by spoton on 26/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import UIKit
class SearchViewController:  UIViewController{
    @IBOutlet weak var SearchBarNearby: UISearchBar!
    @IBOutlet weak var tableSearhPage: SearchTableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableSearhPage.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false
        tableSearhPage.SetUp(viewController: self)
    }
}

