import UIKit
import SDWebImage
import Mixpanel

class DealCell_OneStep: UITableViewCell {

    var controllerForDeals: DealViewController? = nil
    var mtable: DealTableVC? = nil
    var statusUsePointMenu: Bool = false
    var statusUnUsePointMenu: Bool = false
    var projectToken: String = "1a4f60bd37af4cea7b199830b6bec468"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func SetData(deal: Deal ,mControllerForDeals: DealViewController ,
                 statusUseMenuPoint: Bool , statusUnUsePoint: Bool,
                 table :DealTableVC, AllDealList :[Deal], typeStoreID: Int)
    {
        controllerForDeals = mControllerForDeals
        mtable = table
        statusUsePointMenu = statusUseMenuPoint
        statusUnUsePointMenu = statusUnUsePoint
        
        
        
        if let subview = self.viewWithTag(99) as? UILabel {
            subview.lineBreakMode = .byWordWrapping
            subview.numberOfLines = 0
            if(typeStoreID == 11){
                subview.text = "ส่วนลดรวมโดยประมาณ"
            }else{
                subview.text = "ส่วนลดรวม"
            }
            
        }
        
        
        
        // color bar
        if let subview = self.viewWithTag(101) {
            if (deal.isOwnedDeal!) {
//                subview.backgroundColor = PrimoColor.Green.UIColor
                 subview.backgroundColor = UIColor.clear
            } else {
                subview.backgroundColor = UIColor.clear
//                subview.backgroundColor = PrimoColor.Red.UIColor
            }
        }
        
        // card image
        if let subview = self.viewWithTag(102) as? UIImageView {
            let defaultCard = #imageLiteral(resourceName: "card_error")
            let block = { (image: UIImage?, error: Error?, cache: SDImageCacheType, url: URL?) in
                if (error != nil) {
                    print(error!)
                } else {
                    deal.card?.image = image
                    //print("Got Image")
                }
            }
            subview.sd_setImage(with: URL(string: (deal.card?.imgUrl)!),
                                placeholderImage: defaultCard,
                                options: .retryFailed,
                                completed: block)
        }
        
        // is owned deal text
        if let subview = self.viewWithTag(104) as? UILabel {
            if (deal.isOwnedDeal!) {
                // owned deal
                subview.text = DealPage.UnderCardText_OwnedDeal.rawValue
                subview.textColor = PrimoColor.Green.UIColor
            } else {
                // not owned
                subview.text = DealPage.UnderCardText_NotOwn.rawValue
                subview.textColor = PrimoColor.Red.UIColor
            }
        }
        
        // deal title
        if let subview = self.viewWithTag(105) as? UILabel {
            subview.lineBreakMode = .byWordWrapping
            subview.numberOfLines = 0
            subview.text = deal.title
        }
        
        // deal value
        if let subview = self.viewWithTag(17) as? UILabel {
            let value = deal.totalReward
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
//              subview.text = "฿ "+(formatter.string(from: NSNumber(value: value!)) ?? "0")
            subview.text = (formatter.string(from: NSNumber(value: value!)) ?? "0") + " ฿"
        }
        
        // deal value bg
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
        
        
        //add point credite , debit and member card
        
        if let subview = self.viewWithTag(15) as? UILabel {
            let value = deal.pointCredite
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            subview.text = (formatter.string(from: NSNumber(value: value)) ?? "0")
        }
        
        
        if let subview = self.viewWithTag(14) as? UILabel {
            let value = deal.pointMemberCard
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            subview.text = (formatter.string(from: NSNumber(value: value)) ?? "0")
        }
        //End
        
        
        if let subview = self.viewWithTag(18) {
            subview.clipsToBounds = true
            subview.layer.cornerRadius = 5
            
            
        }
        
        
        
        if let subview = self.viewWithTag(11) as? Button_custom {
            subview.backgroundColor = UIColor.clear
            if(deal.card?.type == .memberCard){
                subview.mDealBuffer.removeAll()
                subview.mDealBuffer = AllDealList
                subview.addTarget(self, action: #selector(sendActionMember), for: .touchUpInside)
            }
           
        }
        
        
        if let subview = self.viewWithTag(12) as? Button_custom {
            subview.backgroundColor = UIColor.clear
            
            if(deal.card?.type != .memberCard){
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
                    subview.image = #imageLiteral(resourceName: "primo_rec")
                    break
                case 2:
                    subview.image = nil
//                    subview.image = #imageLiteral(resourceName: "medal_sliver")
                    break
                case 3:
                    subview.image = nil
//                    subview.image = #imageLiteral(resourceName: "medal_bronze")
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
            DialogEditePoint.shared.Show(deal :[value.mDealBuffer[index]],controller: controllerForDeals!, statusCard: 1, stepCard: 1)
            print("sendActionCredite")

            sendEventForMixpanal(EventName: "i_DealSel_CreditPtsEdite")

        }
    }
    
    @objc func sendActionMember(_ sender: Any)  {
        if(statusUsePointMenu && statusUnUsePointMenu != true){
            let value = sender as! Button_custom
            let index:Int = (mtable!.tableView.indexPath(for: self)?.row)!
            if(value.mDealBuffer[index].isStorewide == true){
                print("isStorewide : true")
            }else{
               DialogEditePoint.shared.Show(deal :[value.mDealBuffer[index]],controller: controllerForDeals!, statusCard: 4, stepCard: 1)
                
                sendEventForMixpanal(EventName: "i_DealSel_MemPtsEdite")
            }
            
            print("sendActionMember")
        }
    }
    
    
    func sendEventForMixpanal(EventName : String){
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        Mixpanel.initialize(token: projectToken)
        Mixpanel.mainInstance().track(event: EventName)
        Mixpanel.mainInstance().identify(distinctId: uuid)
    }
    
}
