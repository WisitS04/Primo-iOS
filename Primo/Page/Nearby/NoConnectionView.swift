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
    var buttonView = UIButton()
    
    class var shared: NoConnectionView
    {
        struct Static
        {
            static let instance: NoConnectionView = NoConnectionView()
        }
        return Static.instance
    }
    
    public func Show(view: UIView) {
        let viewSize = UIScreen.main.bounds
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.center = view.center
        mainView.backgroundColor = UIColor.white
        mainView.alpha = 0
        
        view.addSubview(mainView)
    }
    
    public func Hide() {
        mainView.removeFromSuperview()
    }
}
