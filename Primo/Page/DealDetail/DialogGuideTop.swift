//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class DialogGuideTop
{
    var mainView = UIView()
    var imageView = UIImageView()
    var imageViewBG = UIImageView()
    var button = UIButton()
    var dialogView = UIView()
    var dialogViewBG = UIView()
    var SegmentSize :CGFloat = 50
    var mView: UIView?
    var mNavigation: UINavigationController?
    
    class var shared: DialogGuideTop
    {
        struct Static
        {
            static let instance: DialogGuideTop = DialogGuideTop()
        }
        return Static.instance
    }
    
    
    public func Show(view: UIView, navigationController: UINavigationController) {
        let viewSize = UIScreen.main.bounds
        let hightStatusBar = UIApplication.shared.statusBarFrame.height
        
        mView = view
        mNavigation = navigationController
        
        let navigationBarHeight: CGFloat = navigationController.navigationBar.frame.height
        let navigationBarWidth: CGFloat = navigationController.navigationBar.frame.width
        
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.center = view.center
        mainView.backgroundColor = UIColor.clear
        mainView.contentMode = UIViewContentMode.scaleAspectFit
        mainView.alpha = 1
        
        imageViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageViewBG.contentMode = .scaleAspectFit
        if(viewSize.height >= 812 && viewSize.width >= 375){
            //is iPhone X
            imageViewBG.image = UIImage(named: "bg_guide_deals_top_x")
        }else{
            imageViewBG.image = UIImage(named: "bg_guide_deals_top")
        }
        mainView.addSubview(imageViewBG)
        
        
        
        imageView.frame = CGRect(x: (navigationBarWidth-257)-15,
                                 y: hightStatusBar + navigationBarHeight,
                                 width: 257,
                                 height: 115)
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = UIColor.gray
        imageView.image = UIImage(named: "duble_circle")
        mainView.addSubview(imageView)
        
    
        
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
         DialogGuideBottom.shared.Show(view: mView!, navigationController: mNavigation!)
    }
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
    
}
