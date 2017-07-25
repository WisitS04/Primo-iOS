//
//  LoadingOverlay.swift
//  Primo
//
//  Created by Macmini on 3/8/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

public class LoadingOverlay
{
    var mainView = UIView()
    var dialogView = UIView()
    var indicator = UIActivityIndicatorView()
    
    var mainViewLoopGPS = UIView()
    var dialogLoopGPS = UIView()
    var indicatorLoopGPS = UIActivityIndicatorView()
    
    var mainViewNoInternet = UIView()
    var dialogNoInterner = UIView()

    var closeAction: ((_ isOtherButton: Bool) -> Void)? = nil
    
    class var shared: LoadingOverlay
    {
        struct Static
        {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView)
    {
        let screenSize = UIScreen.main.bounds
        mainView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        mainView.center = view.center
        mainView.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainView.alpha = 1
        
        dialogView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        dialogView.center = mainView.center
        dialogView.backgroundColor = HexStringToUIColor(hex: "#444444")
        dialogView.alpha = 0.9
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 10
        mainView.addSubview(dialogView)
        
        
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = CGPoint(x: dialogView.bounds.width / 2,
                                   y: dialogView.bounds.height / 2)
        indicator.startAnimating()
        dialogView.addSubview(indicator)
        
        view.addSubview(mainView)
    }
    
    
    public func showDialogLoopGPS(view: UIView, action: ((Bool) -> Void)?){
        let screenSize = UIScreen.main.bounds
        mainViewLoopGPS.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        mainViewLoopGPS.center = view.center
        mainViewLoopGPS.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainViewLoopGPS.alpha = 1
        
        dialogLoopGPS.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        dialogLoopGPS.center = mainViewLoopGPS.center
        dialogLoopGPS.backgroundColor = HexStringToUIColor(hex: "#444444")
        dialogLoopGPS.alpha = 0.9
        dialogLoopGPS.clipsToBounds = true
        dialogLoopGPS.layer.cornerRadius = 10
        mainViewLoopGPS.addSubview(dialogLoopGPS)
        
        
        indicatorLoopGPS.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicatorLoopGPS.activityIndicatorViewStyle = .whiteLarge
        indicatorLoopGPS.center = CGPoint(x: dialogLoopGPS.bounds.width / 2,
                                   y: dialogLoopGPS.bounds.height / 3)
        indicatorLoopGPS.startAnimating()
        dialogLoopGPS.addSubview(indicatorLoopGPS)
        
        let textGPS = UITextView(frame: CGRect(x: 0, y: 0, width: 145, height: 30))
        textGPS.text = "กำลังค้นหาตำแหน่งขอคุณ"
        textGPS.center = CGPoint(x: dialogLoopGPS.bounds.width / 2,
                                 y: dialogLoopGPS.bounds.height / 1.7)
        textGPS.backgroundColor = HexStringToUIColor(hex: "#444444")
        textGPS.textColor = UIColor.white
        dialogLoopGPS.addSubview(textGPS)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        button.setTitle("Cancel", for: .normal)
        button.center = CGPoint(x: dialogLoopGPS.bounds.width / 2,
                                y: dialogLoopGPS.bounds.height / 1.2)
        button.backgroundColor = HexStringToUIColor(hex: "#00FFFF")
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if(action != nil) {
            closeAction = action
            button.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        }
        
        dialogLoopGPS.addSubview(button)

        view.addSubview(mainViewLoopGPS)
    }
    
    
    
    @objc func sendAction(_ sender: UIButton!)  {
        hideOverlayViewGPS()
        if(closeAction != nil) {
            closeAction!(true)
        }
    }
    
    public func hideOverlayViewGPS()
    {
        indicatorLoopGPS.stopAnimating()
        mainViewLoopGPS.removeFromSuperview()
    }
    
    public func hideOverlayView()
    {
        indicator.stopAnimating()
        mainView.removeFromSuperview()
    }
}
