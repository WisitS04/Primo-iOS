//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class GuideForNearby
{
    var mainView = UIView()
    var imageView = UIImageView()
    var button = UIButton()
    var dialogView = UIView()
    var dialogViewBG = UIView()
    var myStotybord : UIStoryboard? = nil
    var myNavigationController: UINavigationController? = nil
    var StatusDrawTable: Bool = false
    class var shared: GuideForNearby
    {
        struct Static
        {
            static let instance: GuideForNearby = GuideForNearby()
        }
        return Static.instance
    }
    
    
    public func Show(view: UIView, navigationController: UINavigationController, storyboard :UIStoryboard, statusDrawTable :Bool) {
        myStotybord = storyboard
        myNavigationController = navigationController
        StatusDrawTable = statusDrawTable
        
        let viewSize = UIScreen.main.bounds
        let hightStatusBar = UIApplication.shared.statusBarFrame.height
        
        let navigationBarHeight: CGFloat = navigationController.navigationBar.frame.height
        let navigationBarWidth: CGFloat = navigationController.navigationBar.frame.width
        
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.center = view.center
        mainView.backgroundColor = UIColor.clear
        mainView.contentMode = UIViewContentMode.scaleAspectFit
        mainView.alpha = 1
//        guide_nearby
        
        imageView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageView.contentMode = .scaleAspectFit
        if(viewSize.height >= 812 && viewSize.width >= 375){
            //is iPhone X
             imageView.image = UIImage(named: "guide_nearby_x")
        }else{
             imageView.image = UIImage(named: "guide_nearby")
        }
       
        mainView.addSubview(imageView)
        
        dialogViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        dialogViewBG.center = mainView.center
//        dialogViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
        dialogViewBG.backgroundColor = UIColor.clear
        dialogViewBG.contentMode = .scaleAspectFit
        dialogViewBG.alpha = 0.5
        dialogViewBG.clipsToBounds = true
        //        dialogViewBG.layer.cornerRadius = 4
        mainView.addSubview(dialogViewBG)
        
        
        
        dialogView.frame = CGRect(x: 0, y: 0, width: navigationBarWidth, height: navigationBarHeight + hightStatusBar)
        dialogView.backgroundColor = UIColor.clear
        dialogView.alpha = 1
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 4
        mainView.addSubview(dialogView)
        
        button.frame = CGRect(x: (dialogView.bounds.width - (navigationBarHeight * 2))-20,
                              y: hightStatusBar, width: navigationBarHeight+20, height: navigationBarHeight)
        button.setTitle("add", for: .normal)
//        button.backgroundColor = HexStringToUIColor(hex: PrimoColor.Smoke.rawValue)
        button.setImage(UIImage(named: "add_card_button"), for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        button.isEnabled = true
        dialogView.addSubview(button)
        

        
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(mainView)
        window.bringSubview(toFront: mainView)
        mainView.frame = window.bounds
        
    }
    
    
    @objc func sendActionData(_ sender: Any)  {
        if(myStotybord != nil && myNavigationController != nil && StatusDrawTable != true){
            Hide()
            let secondViewController = myStotybord?.instantiateViewController(withIdentifier: "AddCardController") as! AddCardController
            myNavigationController?.pushViewController(secondViewController, animated: true)
            


            VersionGuideNearby.set(cerrentVersin,forKey: KEYGuideNeayBy)
        }
    }
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
    
}
