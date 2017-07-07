//
//  AddCardTabBarController.swift
//  Primo
//
//  Created by Macmini on 1/20/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

import UIKit

class AddCardTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews()
    {
        //make changes in frame here according to orientation if any
        self.tabBar.frame = CGRect(x: 00, y: 40, width:self.view.bounds.size.width, height: 50)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
