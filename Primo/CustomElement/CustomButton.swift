//
//  GrayButton.swift
//  Primo
//
//  Created by Macmini on 1/30/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

import UIKit

class GrayButton: UIButton
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bgColor = HexStringToUIColor(hex: "#F2F2F2")
        backgroundColor = bgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = bgColor.cgColor
        setTitleColor(UIColor.black, for: .normal)
    }
}

class GreenButton: UIButton
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bgColor = HexStringToUIColor(hex: "#3FBCA4")
        backgroundColor = bgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = bgColor.cgColor
        setTitleColor(UIColor.white, for: .normal)
    }
}

class GrayLabel: UILabel
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bgColor = HexStringToUIColor(hex: "#F2F2F2")
        backgroundColor = bgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = bgColor.cgColor
        textColor = UIColor.black
    }
}

class DealFilterButton: UIButton
{
    var isUsing: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let bgColor = HexStringToUIColor(hex: "#F2F2F2")
        backgroundColor = bgColor
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = bgColor.cgColor
        setTitleColor(UIColor.black, for: .normal)
    }
    
    func OnUsing() {
        let bgColor = HexStringToUIColor(hex: "#3FBCA4")
        backgroundColor = bgColor
        layer.borderColor = bgColor.cgColor
        setTitleColor(UIColor.white, for: .normal)
    }
    
    func OnUnuse() {
        let bgColor = HexStringToUIColor(hex: "#F2F2F2")
        backgroundColor = bgColor
        layer.borderColor = bgColor.cgColor
        setTitleColor(UIColor.black, for: .normal)
    }
}

class SendSMSButton: GreenButton
{
    var smsMsg: String?
    var smsDesc: String?
    var smsNumber: String?
}
