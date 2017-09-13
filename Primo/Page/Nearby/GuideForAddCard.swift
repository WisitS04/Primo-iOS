//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class GuideForAddCard
{
    var mainView = UIView()
    var imageView = UIImageView()
    var imageViewBG = UIImageView()
    var button = UIButton()
    var dialogView = UIView()
    var dialogViewBG = UIView()
    var SegmentSize :CGFloat = 50
    class var shared: GuideForAddCard
    {
        struct Static
        {
            static let instance: GuideForAddCard = GuideForAddCard()
        }
        return Static.instance
    }
    
    
    public func Show(view: UIView, navigationController: UINavigationController) {
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
        
        imageViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageViewBG.contentMode = .scaleAspectFit
        imageViewBG.image = UIImage(named: "guide_add_card")
        mainView.addSubview(imageViewBG)
        
//        dialogViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
////        dialogViewBG.center = mainView.center
////                dialogViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
//        dialogViewBG.backgroundColor = UIColor.clear
//        dialogViewBG.contentMode = .scaleAspectFit
//        dialogViewBG.alpha = 0.5
//        dialogViewBG.clipsToBounds = true
//        //        dialogViewBG.layer.cornerRadius = 4
//        mainView.addSubview(dialogViewBG)
        
        
        imageView.frame = CGRect(x: 0, y: hightStatusBar, width: navigationBarWidth, height: SegmentSize + hightStatusBar + navigationBarHeight)
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = UIColor.gray
        imageView.image = UIImage(named: "cover_add_card")
        mainView.addSubview(imageView)
        
        
//        dialogView.frame = CGRect(x: 0, y: hightStatusBar, width: navigationBarWidth, height: SegmentSize + hightStatusBar + navigationBarHeight)
//        dialogView.backgroundColor = HexStringToUIColor(hex: "#444444")
//        dialogView.alpha = 1
//        dialogView.clipsToBounds = true
//        dialogView.layer.cornerRadius = 4
//        mainView.addSubview(dialogView)
        
        
        
        button.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        button.isEnabled = true
        mainView.addSubview(button)
        
        
        
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(mainView)
        window.bringSubview(toFront: mainView)
        mainView.frame = window.bounds
        
    }
    
    
    @objc func sendActionData(_ sender: Any)  {
            Hide()
    }
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
    
}
