//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class GuideForDetail
{
    var mainView = UIView()
    var imageViewBG = UIImageView()
    var imageViewDep = UIImageView()
    var imageViewPrice = UIImageView()
    var imageViewDiscount = UIImageView()
    var button = UIButton()
    var dialogView = UIView()
    var dialogViewBG = UIView()
    
    
    var HeaderHight: CGFloat = 90
    var HeaderTitleHight: CGFloat = 17
    var ButtonItemHight: CGFloat = 30
    
    var spaceButtonForHeaderTitleHight = 10
    var spaceButtonForSection: CGFloat = 20
    
    var sumHightForSetion: CGFloat = 57
    
    class var shared: GuideForDetail
    {
        struct Static
        {
            static let instance: GuideForDetail = GuideForDetail()
        }
        return Static.instance
    }
    
    
    public func Show(view: UIView, navigationController: UINavigationController , MydepartmentCount: Int) {
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
        if(MydepartmentCount > 0){
           imageViewBG.image = UIImage(named: "guide_detail_dep")
        }else{
           imageViewBG.image = UIImage(named: "guide_detail_not_dep")
        }
        mainView.addSubview(imageViewBG)

        
//        
//        dialogViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
//        dialogViewBG.center = mainView.center
//        dialogViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
//        //        dialogViewBG.backgroundColor = UIColor.clear
//        dialogViewBG.contentMode = .scaleAspectFit
//        dialogViewBG.alpha = 0.5
//        dialogViewBG.clipsToBounds = true
//        //        dialogViewBG.layer.cornerRadius = 4
//        mainView.addSubview(dialogViewBG)
        
        

        
        
        if(MydepartmentCount > 0){
            imageViewDep.frame = CGRect(x: (navigationBarWidth/2)-((sumHightForSetion+spaceButtonForSection+HeaderTitleHight)/2),
                                        y: hightStatusBar+navigationBarHeight+HeaderHight+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                        width: sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                        height: sumHightForSetion)
            imageViewDep.contentMode = .scaleAspectFit
            imageViewDep.image = UIImage(named: "curve_dep")
            mainView.addSubview(imageViewDep)
            
            
            imageViewPrice.frame = CGRect(x: (navigationBarWidth/2)-((sumHightForSetion+spaceButtonForSection+HeaderTitleHight)/2),
                                          y: hightStatusBar+navigationBarHeight+HeaderHight+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                          width: sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                          height: sumHightForSetion)
            imageViewPrice.contentMode = .scaleAspectFit
            //        imageViewPrice.backgroundColor = UIColor.gray
            imageViewPrice.image = UIImage(named: "curve_price")
            mainView.addSubview(imageViewPrice)
            
            
            imageViewDiscount.frame = CGRect(x: (navigationBarWidth/4)-((sumHightForSetion+spaceButtonForSection+HeaderTitleHight)/2),
                                             y: hightStatusBar+navigationBarHeight+HeaderHight+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                             width: sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                             height: sumHightForSetion)
            imageViewDiscount.contentMode = .scaleAspectFit
            //        imageViewDiscount.backgroundColor = UIColor.gray
            imageViewDiscount.image = UIImage(named: "curve_discount")
            mainView.addSubview(imageViewDiscount)
            
        }else{
            imageViewPrice.frame = CGRect(x: (navigationBarWidth/2)-((sumHightForSetion+spaceButtonForSection+HeaderTitleHight)/2),
                                          y: hightStatusBar+navigationBarHeight+HeaderHight+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                          width: sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                          height: sumHightForSetion)
            imageViewPrice.contentMode = .scaleAspectFit
            //        imageViewPrice.backgroundColor = UIColor.gray
            imageViewPrice.image = UIImage(named: "curve_price")
            mainView.addSubview(imageViewPrice)
            
            
            imageViewDiscount.frame = CGRect(x: (navigationBarWidth/4)-((sumHightForSetion+spaceButtonForSection+HeaderTitleHight)/2),
                                             y: hightStatusBar+navigationBarHeight+HeaderHight+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                             width: sumHightForSetion+spaceButtonForSection+HeaderTitleHight,
                                             height: sumHightForSetion)
            imageViewDiscount.contentMode = .scaleAspectFit
            //        imageViewDiscount.backgroundColor = UIColor.gray
            imageViewDiscount.image = UIImage(named: "curve_discount")
            mainView.addSubview(imageViewDiscount)
        }

        
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
