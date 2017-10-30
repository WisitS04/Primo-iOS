//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class NotificationDialog
{
    var mainView = UIView()
    var imageViewBG = UIImageView()
    var checkBox = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    var dialogView = UIView()
    var dialogViewBG = UIView()
    let textContent = UILabel()
    
    class var shared: NotificationDialog
    {
        struct Static
        {
            static let instance: NotificationDialog = NotificationDialog()
        }
        return Static.instance
    }
    
    
    public func Show(mTable: UITableView) {
        let viewSize = UIScreen.main.bounds
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainView.contentMode = UIViewContentMode.scaleAspectFill
        mainView.alpha = 1
        
        
        imageViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageViewBG.contentMode = .scaleAspectFit
        imageViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
        imageViewBG.alpha = 0.5
        mainView.addSubview(imageViewBG)
        
        
        
        
        dialogView.frame = CGRect(x: (mainView.bounds.width-270)/2, y: mainView.bounds.height/2.5, width: 270, height: 195)
        dialogView.backgroundColor = UIColor.white
        dialogView.alpha = 1
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 8
        mainView.addSubview(dialogView)
        
        
        
        
        
        let textHeader = UILabel(frame: CGRect(x: 0, y: 30, width: dialogView.bounds.width, height: 30))
        textHeader.numberOfLines = 0;
        textHeader.backgroundColor = UIColor.white
        textHeader.textColor = UIColor.black
        textHeader.text = "ไม่พบรายการ"
        textHeader.font  = UIFont.boldSystemFont(ofSize: 16.0)
        textHeader.textAlignment = .center
        dialogView.addSubview(textHeader)
        
        
        
        textContent.frame = CGRect(x: 22, y: 70, width: dialogView.bounds.width-48, height: 70)
        textContent.backgroundColor = UIColor.white
        textContent.textColor = UIColor.black
        textContent.textAlignment = .center
        textContent.font = textContent.font.withSize(15)
        textContent.numberOfLines = 0
        textContent.text = "บัตรที่คุณมี \nหรือเงื่อนไขที่เลือกไม่มีโปรโมชั่น"
        dialogView.addSubview(textContent)
        
        
        
        
    
        
        
        let button =  UIButton(frame: CGRect(x: 0, y: 150, width: dialogView.bounds.width, height: 48))
        button.setTitle("ตกลง", for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        dialogView.addSubview(button)
        
        
        
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(mainView)
        window.bringSubview(toFront: mainView)
        mainView.frame = window.bounds
        
        //        view.addSubview(mainView)
        
    }
    
    
    @objc func sendActionData(_ sender: Any)  {
        Hide()
    }
    
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
    
}
