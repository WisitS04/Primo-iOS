//
//  LoadingOverlayGPS.swift
//  Primo
//
//  Created by Macmini on 3/8/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

public class LoadingOverlayGPS
{
    var mainView = UIView()
    var dialogView = UIView()
    var indicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlayGPS
    {
        struct Static
        {
            static let instance: LoadingOverlayGPS = LoadingOverlayGPS()
        }
        return Static.instance
    }
    
    public func showOverlayGPS(view: UIView)
    {
        let screenSize = UIScreen.main.bounds
        mainView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        mainView.center = view.center
        mainView.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainView.alpha = 1
        
        dialogView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        dialogView.center = mainView.center
        dialogView.backgroundColor = HexStringToUIColor(hex: "#444444")
        dialogView.alpha = 0.9
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 10
        
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        btn.backgroundColor = UIColor.green
        btn.setTitle("Click Me", for: .normal)
        btn.center = CGPoint(x: dialogView.bounds.width / 2,
                            y: dialogView.bounds.height / 2)
        view.addSubview(btn)
        
        
        mainView.addSubview(dialogView)
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = CGPoint(x: dialogView.bounds.width / 2,
                                   y: dialogView.bounds.height / 2)
        indicator.startAnimating()
        dialogView.addSubview(indicator)
        
        view.addSubview(mainView)
    }
    
    public func hideOverlayGPSView()
    {
        indicator.stopAnimating()
        mainView.removeFromSuperview()
    }
}
