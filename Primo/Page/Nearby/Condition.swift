//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class Conidion
{
    var mainView = UIView()
    var imageView = UIImageView()
    var button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    var checkBox = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    var dialogView = UIView()
    var dialogViewBG = UIView()
    var statusCheck: Bool = false
    
    var Action: ((_ Button: Bool) -> Void)? = nil
    
    class var shared: Conidion
    {
        struct Static
        {
            static let instance: Conidion = Conidion()
        }
        return Static.instance
    }
    
    
    public func Show(view: UIView,  action: ((Bool) -> Void)?) {
        let viewSize = UIScreen.main.bounds
        statusCheck = false
    
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mainView.center = view.center
        mainView.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainView.contentMode = UIViewContentMode.scaleAspectFill
        mainView.alpha = 1
        
        
        
        dialogViewBG.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        dialogViewBG.center = mainView.center
        dialogViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
        dialogViewBG.alpha = 0.5
        dialogViewBG.clipsToBounds = true
//        dialogViewBG.layer.cornerRadius = 4
        mainView.addSubview(dialogViewBG)
        
        
        dialogView.frame = CGRect(x: 0, y: 0, width: 250, height: 220)
        dialogView.center = mainView.center
        dialogView.backgroundColor = UIColor.white
        dialogView.alpha = 1
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 4
        mainView.addSubview(dialogView)
        
        

    

        let textHeader = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        textHeader.center = CGPoint(x: dialogView.bounds.width / 2,
                                    y: dialogView.bounds.height - (dialogView.bounds.height - 20))
        textHeader.numberOfLines = 0;
        textHeader.backgroundColor = UIColor.white
        textHeader.textColor = UIColor.black
        textHeader.text = "ข้อตกลงและเงื่อนไข"
        dialogView.addSubview(textHeader)
        
        
        let buttonLink = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 50))
        buttonLink.center = CGPoint(x: dialogView.bounds.width / 2.2,
                                 y: dialogView.bounds.height / 2.6)
   
        buttonLink.setTitle("ข้อตกลงและเงื่อนไข",for: .normal)
        buttonLink.setTitleColor(UIColor.blue, for: .normal)
        buttonLink.backgroundColor = UIColor.white
        buttonLink.titleLabel?.lineBreakMode = .byWordWrapping
        if(action != nil){
             buttonLink.addTarget(self, action: #selector(UrlLink), for: .touchUpInside)
        }
        dialogView.addSubview(buttonLink)
        
        
        checkBox.removeTarget(nil, action: nil, for: .allEvents)
        checkBox.center = CGPoint(x: dialogView.bounds.width - (dialogView.bounds.width - 25),
                                  y: dialogView.bounds.height / 1.7)
       
        if(action != nil) {
            Action = action
            checkBox.addTarget(self, action: #selector(OnCheck), for: .touchUpInside)
        }
        
        checkBox.setImage(#imageLiteral(resourceName: "icon_check"), for: .selected)
        checkBox.setImage(#imageLiteral(resourceName: "icon_uncheck"), for: .normal)
        dialogView.addSubview(checkBox)
        
        
        let textContent = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 50))
        textContent.center = CGPoint(x: dialogView.bounds.width - 120,
                                     y: dialogView.bounds.height / 1.6)
        textContent.numberOfLines = 0;
        textContent.backgroundColor = UIColor.white
        textContent.textColor = UIColor.black
        textContent.text = "ฉันตกลงและยอมรับเงื่อนไข"
        dialogView.addSubview(textContent)
        
        
        button.setTitle("ยอมรับ", for: .normal)
        button.center = CGPoint(x: dialogView.bounds.width / 2,
                                y: dialogView.bounds.height / 1.2)
        button.backgroundColor = HexStringToUIColor(hex: PrimoColor.Smoke.rawValue)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        if(action != nil) {
            button.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        }
        
        button.isEnabled = true
        dialogView.addSubview(button)
        
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(mainView)
        window.bringSubview(toFront: mainView)
        mainView.frame = window.bounds

//        view.addSubview(mainView)
        
    }
    
     @objc func UrlLink(_ sender: Any){
        let url = URL(string: "http://terms.primo.mobi/")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
          Action!(false)
    }
    
    @objc func OnCheck(_ sender: Any) {
        if let btn = sender as? UIButton {
            btn.isSelected = !btn.isSelected
            if (btn.isSelected) {
                button.backgroundColor = HexStringToUIColor(hex: PrimoColor.Green.rawValue)
                button.isEnabled = true
                statusCheck = true
            } else {
                button.backgroundColor = HexStringToUIColor(hex: PrimoColor.Smoke.rawValue)
                button.isEnabled = false
                statusCheck = false
            }
       }
          Action!(false)
    }
    
    @objc func sendActionData(_ sender: Any)  {
         Action!(statusCheck)
    }
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }

}
