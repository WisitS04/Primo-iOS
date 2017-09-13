//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class DialogForMyCard
{
    var mainView = UIView()
    var imageViewBG = UIImageView()
    var checkBox = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    var dialogView = UIView()
    var dialogViewBG = UIView()
    let textContent = UITextField()
    var mTableView: MyCard_TableView?
    var mID: Int64?
    
    class var shared: DialogForMyCard
    {
        struct Static
        {
            static let instance: DialogForMyCard = DialogForMyCard()
        }
        return Static.instance
    }
    
    
    public func Show(mPoint :Int ,id : Int64, mTable: UITableView) {
        let viewSize = UIScreen.main.bounds
        mTableView = mTable as! MyCard_TableView
        mID = id
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainView.contentMode = UIViewContentMode.scaleAspectFill
        mainView.alpha = 1
        
        
        imageViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageViewBG.contentMode = .scaleAspectFit
        imageViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
        imageViewBG.alpha = 0.5
        mainView.addSubview(imageViewBG)

        
        
        
        dialogView.frame = CGRect(x: (mainView.bounds.width-270)/2, y: mainView.bounds.height/4, width: 270, height: 165)
        dialogView.backgroundColor = UIColor.white
        dialogView.alpha = 1
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 5
        mainView.addSubview(dialogView)
        
        
        
        
        
        let textHeader = UILabel(frame: CGRect(x: 0, y: 32.5, width: dialogView.bounds.width, height: 30))
        textHeader.numberOfLines = 0;
        textHeader.backgroundColor = UIColor.white
        textHeader.textColor = UIColor.black
        textHeader.text = "ใส่คะแนน"
        textHeader.textAlignment = .center
        dialogView.addSubview(textHeader)
        
        
        
        textContent.frame = CGRect(x: 22, y: 80, width: dialogView.bounds.width-48, height: 24)
        textContent.backgroundColor = UIColor.white
        textContent.textAlignment = .center
        textContent.text = String(mPoint)
//        textContent.placeholder = String(mPoint)
        textContent.keyboardType = UIKeyboardType.numberPad
        textContent.becomeFirstResponder()
        textContent.layer.cornerRadius = 2
        textContent.layer.borderWidth = 1
        textContent.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        dialogView.addSubview(textContent)
        
        
        
        
        
        let buttonLink = UIButton(frame: CGRect(x: 0, y: 120, width: dialogView.bounds.width/2, height: 48))

        
        buttonLink.setTitle("Cancel",for: .normal)
        buttonLink.setTitleColor(UIColor.blue, for: .normal)
        buttonLink.backgroundColor = UIColor.white
        buttonLink.titleLabel?.lineBreakMode = .byWordWrapping
        buttonLink.layer.borderWidth = 1
        buttonLink.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        buttonLink.addTarget(self, action: #selector(UrlLink), for: .touchUpInside)
        dialogView.addSubview(buttonLink)
        
    
        let button =  UIButton(frame: CGRect(x: dialogView.bounds.width/2, y: 120, width: dialogView.bounds.width/2, height: 48))
        button.setTitle("OK", for: .normal)
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
    
    @objc func UrlLink(_ sender: Any){
        textContent.text = ""
        Hide()
    }

    
    @objc func sendActionData(_ sender: Any)  {
        if((textContent.text?.length)! > 0){
            mTableView?.confrimDialog(value :Int(textContent.text!)!,id: mID!)
  
        }
            Hide()
    }
    
    
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
    
}
