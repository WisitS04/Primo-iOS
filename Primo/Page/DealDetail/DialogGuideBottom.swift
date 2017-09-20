//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class DialogGuideBottom
{
    var mainView = UIView()
    var imageView = UIImageView()
    var imageView2 = UIImageView()
    var imageViewBG = UIImageView()
    var button = UIButton()
    var dialogView = UIView()
    var dialogViewBG = UIView()
    var SegmentSize :CGFloat = 50
    class var shared: DialogGuideBottom
    {
        struct Static
        {
            static let instance: DialogGuideBottom = DialogGuideBottom()
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
        
        imageViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageViewBG.contentMode = .scaleAspectFit
        imageViewBG.image = UIImage(named: "bg_guide_deals_bottom")
        mainView.addSubview(imageViewBG)
        
        
        
        imageView.frame = CGRect(x: 0,
                                 y: hightStatusBar + navigationBarHeight  + 218.5,
                                 width: navigationBarWidth,
                                 height: 31.5)
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = UIColor.gray
                imageView.image = UIImage(named: "big_circle")
        mainView.addSubview(imageView)
        
        
        
        imageView2.frame = CGRect(x: (navigationBarWidth - 160)-16,
                                 y: hightStatusBar + navigationBarHeight  + 260,
                                 width: 170,
                                 height: 48.5)
        imageView2.contentMode = .scaleAspectFill
//        imageView2.backgroundColor = UIColor.green
        imageView2.image = UIImage(named: "small_circle")
        mainView.addSubview(imageView2)
        
        
        
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
        StatusGuideDeals.set(true,forKey: KEYGuideDeals)
    }
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
    
}
