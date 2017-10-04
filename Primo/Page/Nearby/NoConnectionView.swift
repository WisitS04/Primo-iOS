//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

class NoConnectionView
{
    var mainView = UIView()
    var imageView = UIImageView()
    var button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
    var dialogView = UIView()

    
    var Action: ((_ Button: Bool) -> Void)? = nil
    
    class var shared: NoConnectionView
    {
        struct Static
        {
            static let instance: NoConnectionView = NoConnectionView()
        }
        return Static.instance
    }
    
    public func Show(view: UIView,  action: ((Bool) -> Void)?) {
        let viewSize = UIScreen.main.bounds
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.center = view.center
        mainView.backgroundColor = UIColor.white
        mainView.alpha = 1
        
        
        
        dialogView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        dialogView.center = mainView.center
        dialogView.backgroundColor = HexStringToUIColor(hex: "#ffffff")
        dialogView.alpha = 1
        dialogView.clipsToBounds = true
//        dialogView.layer.cornerRadius = 10
        mainView.addSubview(dialogView)
        
        
        let imageName = "lost_internet.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height/1.7)
        imageView.center = CGPoint(x: dialogView.bounds.width / 2,
                                   y: dialogView.bounds.height/2.8)
        dialogView.addSubview(imageView)
        
        
        button.setTitle("ลองอีกครั้ง", for: .normal)
        button.center = CGPoint(x: dialogView.bounds.width / 2,
                                y: dialogView.bounds.height / 1.6)
        button.backgroundColor = HexStringToUIColor(hex: PrimoColor.Green.rawValue)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        if(action != nil) {
            Action = action
            button.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        }

        dialogView.addSubview(button)
        
        
        view.addSubview(mainView)
    }
    
    @objc func sendActionData(_ sender: UIButton!)  {
        if(Action != nil) {
            UIView.animate(withDuration: 0.6,animations: {
                self.button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },completion: { _ in UIView.animate(withDuration: 0.15) {
                self.button.transform = CGAffineTransform.identity
                }
            })
            
            Action!(true)
        }
    }
    

    
    public func Hide() {
        mainView.removeFromSuperview()
    }
}
