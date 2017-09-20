//
//  DealCell_TwoStep.swift
//  Primo
//
//  Created by Macmini on 3/31/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

import UIKit
import SDWebImage

class DealCell_TwoStep: UITableViewCell {

    var controllerForDeals: DealViewController? = nil
    var UrlFirstCard: String = ""
    var UrlNotFirstCard: String = ""
    var mtable: DealTableVC? = nil
    var statusUsePointMenu: Bool = false
    var statusUnUsePointMenu: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func SetData(deal: Deal ,mControllerForDeals: DealViewController,
                 statusUseMenuPoint: Bool, statusUnUsePoint: Bool,
                 table :DealTableVC, AllDealList :[Deal])
    {
       controllerForDeals = mControllerForDeals
       mtable = table
       statusUsePointMenu = statusUseMenuPoint
       statusUnUsePointMenu = statusUnUsePoint
        
        // color bar
        if let subview = self.viewWithTag(101) {
//            if (deal.isOwnedDeal!) {
//                subview.backgroundColor = PrimoColor.Green.UIColor
//            } else {
//                subview.backgroundColor = PrimoColor.Red.UIColor
//            }
            subview.backgroundColor = UIColor.clear
        }
        
        // card image
        // fore card
        
        if(deal.card?.type != .memberCard){
            UrlFirstCard = (deal.card?.imgUrl)!
            UrlNotFirstCard = (deal.Childs?.card?.imgUrl)!
        }else{
            if(deal.Childs?.card?.type != .memberCard){
                UrlFirstCard = (deal.Childs?.card?.imgUrl)!
                UrlNotFirstCard = (deal.card?.imgUrl)!
            }else{
                UrlFirstCard = (deal.card?.imgUrl)!
                UrlNotFirstCard = (deal.Childs?.card?.imgUrl)!
            }
        }
        
        
        
        
        if let subview = self.viewWithTag(102) as? UIImageView {
            let defaultCard = #imageLiteral(resourceName: "mock_card_3")
            let block = { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
                if (error != nil) {
                    print(error!)
                } else {
                    deal.card?.image = image
                    //print("Got Image")
                }
            }
            subview.sd_setImage(with: URL(string: (UrlFirstCard)),
                                placeholderImage: defaultCard,
                                options: .retryFailed,
                                completed: block)
        }
        // back card
        if let subview = self.viewWithTag(103) as? UIImageView {
            let defaultCard = #imageLiteral(resourceName: "mock_card_2")
            let block = { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
                if (error != nil) {
                    print(error!)
                } else {
                   deal.Childs?.card?.image = image
                    //print("Got Image")
                }
            }
            subview.sd_setImage(with: URL(string: (UrlNotFirstCard)),
                                placeholderImage: defaultCard,
                                options: .retryFailed,
                                completed: block)
        }
//        
//        // is owned deal text
//        if let subview = self.viewWithTag(104) as? UILabel {
//            if (deal.isOwnedDeal!) {
//                // owned deal
//                subview.text = DealPage.UnderCardText_OwnedDeal.rawValue
//                subview.textColor = PrimoColor.Green.UIColor
//            } else {
//                // not owned
//                subview.text = DealPage.UnderCardText_NotOwn.rawValue
//                subview.textColor = PrimoColor.Red.UIColor
//            }
//        }
        
        // deal title
        if let subview = self.viewWithTag(105) as? UILabel {
            subview.lineBreakMode = .byWordWrapping
            subview.numberOfLines = 0
            subview.text = deal.title
        }
        
        // deal value
        if let subview = self.viewWithTag(22) as? UILabel {
            let value = deal.totalReward
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            subview.text = "฿ "+(formatter.string(from: NSNumber(value: value!)) ?? "0") 
        }
        
        // deal value bg
        if let subview = self.viewWithTag(107) {
            subview.clipsToBounds = true
            subview.layer.cornerRadius = 5
        }
        
        //add point credite , debit and member card
        
        if let subview = self.viewWithTag(21) as? UILabel {
            let value = deal.pointCredite
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            subview.text = (formatter.string(from: NSNumber(value: value)) ?? "0")
        }
        
        
        if let subview = self.viewWithTag(20) as? UILabel {
            let value = deal.pointMemberCard
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            subview.text = (formatter.string(from: NSNumber(value: value)) ?? "0")
        }
        //End
        
        if let subview = self.viewWithTag(13) {
            //            subview.clipsToBounds = true
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
            subview.layer.cornerRadius = 5
            
            
        }
        
        
        if let subview = self.viewWithTag(16) {
            //            subview.clipsToBounds = true
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
            subview.layer.cornerRadius = 5
            
            
        }

        
        
        if let subview = self.viewWithTag(23) as? Button_custom {
            subview.backgroundColor = UIColor.clear
        
            
            subview.mBufferDeal? = deal

            if(deal.card?.type == .memberCard
                || deal.Childs?.card?.type == .memberCard){
                subview.mDealBuffer.removeAll()
                subview.mDealBuffer = AllDealList
                subview.addTarget(self, action: #selector(sendActionMember), for: .touchUpInside)

            }
        }
        
        
        if let subview = self.viewWithTag(24) as? Button_custom {
            subview.backgroundColor = UIColor.clear

            subview.mBufferDeal? = deal
            
            if(deal.card?.type != .memberCard
                || deal.Childs?.card?.type != .memberCard){
                subview.mDealBuffer.removeAll()
                subview.mDealBuffer = AllDealList
                subview.addTarget(self, action: #selector(sendActionCredite), for: .touchUpInside)
                
            }
        }
        
        
        // medal image
        if let subview = self.viewWithTag(108) as? UIImageView
        {
            if (deal.rank != nil)
            {
                switch deal.rank! {
                case 1:
                    subview.image = #imageLiteral(resourceName: "medal_gold")
                    break
                case 2:
                    subview.image = #imageLiteral(resourceName: "medal_sliver")
                    break
                case 3:
                    subview.image = #imageLiteral(resourceName: "medal_bronze")
                    break
                default:
                    subview.image = nil
                    break
                }
            } else {
                subview.image = nil
            }
        }
    }
    
    @objc func sendActionCredite(_ sender: Any)  {
        if(statusUsePointMenu && statusUnUsePointMenu != true){
            let value = sender as! Button_custom
            let index:Int = (mtable!.tableView.indexPath(for: self)?.row)!
            DialogEditePoint.shared.Show(deal :[value.mDealBuffer[index]], controller: controllerForDeals!, statusCard: 1)
        
            print("sendActionCredite")
        }
    }
    
    @objc func sendActionMember(_ sender: Any)  {
        if(statusUsePointMenu && statusUnUsePointMenu != true){
            let value = sender as! Button_custom
            let index:Int = (mtable!.tableView.indexPath(for: self)?.row)!
        
            DialogEditePoint.shared.Show(deal :[value.mDealBuffer[index]], controller: controllerForDeals!, statusCard: 4)
            print("sendActionMember")
        }
    }
    
}
