//
//  DealCell_ThreeStep.swift
//  Primo
//
//  Created by Macmini on 3/31/2560 BE.
//  Copyright © 2560 Chalee Pin-klay. All rights reserved.
//

import UIKit
import SDWebImage

class DealCell_ThreeStep: UITableViewCell {
    
    var statusMemberCard: Bool = false
    var statusCrediteCard: Bool = false
    var controllerForDeals: DealViewController? = nil
    var firstCard: String = ""
    var mtable: DealTableVC? = nil
    var statusUsePointMenu: Bool = false
    var statusUnUsePointMenu: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
        func setStepCard(mDeal: Deal){
            if(mDeal.card?.type != .memberCard){
                if(firstCard == ""){
                    firstCard = (mDeal.card?.imgUrl)!
                }
            }
            if(mDeal.Childs != nil){
                setStepCard(mDeal: mDeal.Childs!)
            }
            
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
        firstCard = ""
        setStepCard(mDeal: deal)
        // card image
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
            if(firstCard != ""){
                subview.sd_setImage(with: URL(string: firstCard),
                                    placeholderImage: defaultCard,
                                    options: .retryFailed,
                                    completed: block)
            }else{
                subview.sd_setImage(with: URL(string: (deal.card?.imgUrl)!),
                                    placeholderImage: defaultCard,
                                    options: .retryFailed,
                                    completed: block)
            }

        }
        
        // Download card 2
        let dummyImageView2 = UIImageView()
        dummyImageView2.sd_setImage(
            with: URL(string: (deal.Childs?.card?.imgUrl)!),
            placeholderImage: #imageLiteral(resourceName: "mock_card_3"),
            options: .retryFailed,
            completed: { (i: UIImage?, e: Error?, c: SDImageCacheType, u: URL?) in
                if (e != nil) {
                    print(e!)
                } else {
                    deal.Childs?.card?.image = i
                    print("Deal id:\(String(describing: deal.id)) Got Card Image id:\(String(describing: deal.Childs?.card?.cardId))")
                }
        })
        
        // Download card 3
        let dummyImageView3 = UIImageView()
        dummyImageView3.sd_setImage(
            with: URL(string: (deal.Childs?.Childs?.card?.imgUrl)!),
            placeholderImage: #imageLiteral(resourceName: "mock_card_3"),
            options: .retryFailed,
            completed: { (i: UIImage?, e: Error?, c: SDImageCacheType, u: URL?) in
                if (e != nil) {
                    print(e!)
                } else {
                    deal.Childs?.Childs?.card?.image = i
                    print("Deal id:\(String(describing: deal.id)) Got Card Image id:\(String(describing: deal.Childs?.Childs?.card?.cardId))")
                }
        })
        
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
        if let subview = self.viewWithTag(32) as? UILabel {
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
        
        if let subview = self.viewWithTag(31) as? UILabel {
            let value = deal.pointCredite
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            subview.text = (formatter.string(from: NSNumber(value: value)) ?? "0")
        }
        
        
        if let subview = self.viewWithTag(30) as? UILabel {
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
        
        if let subview = self.viewWithTag(33) as? Button_custom{
            subview.backgroundColor = UIColor.clear
            
            
            statusMemberCard = false
            statusCrediteCard = false
            
            loopCheckTypeCard(mDeal: deal)
            if(statusMemberCard){
                subview.mDealBuffer.removeAll()
                subview.mDealBuffer = AllDealList
                subview.tag = 1
                subview.addTarget(self, action: #selector(sendActionMember), for: .touchUpInside)
                
            }
        }
        
        
        if let subview = self.viewWithTag(34) as? Button_custom {
            subview.backgroundColor = UIColor.clear
            
            statusMemberCard = false
            statusCrediteCard = false
            
            loopCheckTypeCard(mDeal: deal)
            if(statusCrediteCard){
                subview.mDealBuffer.removeAll()
                subview.mDealBuffer = AllDealList
                subview.tag = 2
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
    
    
    
    func loopCheckTypeCard(mDeal: Deal) {
        if(mDeal.Childs != nil){
            if(mDeal.card?.type == .memberCard){
                statusMemberCard = true
            }else{
                statusCrediteCard = true
            }
            return loopCheckTypeCard(mDeal: mDeal.Childs!)
        }else{
            if(mDeal.card?.type == .memberCard){
                statusMemberCard = true
            }else{
                statusCrediteCard = true
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
