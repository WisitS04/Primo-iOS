
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import MessageUI

//
// MARK: - Section Data Structure
//
struct Section {
    var id: Int!
    var index: Int!
    var title: String!
    var cardImage: UIImage!
    var howto: String!
    var description: String!
    var term: String!
    
    var smsMsg: String!
    var smsDesc: String!
    var smsNumber: String!
    
    var collapsed: Bool!
    
    init(index: Int, deal: Deal, isCollapsed: Bool = false) {
        self.index = index
        self.collapsed = isCollapsed
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let pointRequired = formatter.string(from: NSNumber(value: deal.pointRequired!))!
        
        self.id = deal.id
        self.title = deal.nameTh
        self.cardImage = deal.card?.image
        self.howto = "\(deal.proName!) ใช้ทั้งหมด \(pointRequired) แต้ม"
        self.description = deal.description
        self.term = deal.termsAndConditions
        
        self.smsMsg = deal.smsMsg
        self.smsDesc = deal.smsDesc
        self.smsNumber = deal.smsNumber
    }
}

//
// MARK: - View Controller
//
class DealDetailViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var deal: Deal?
    
    var sections = [Section]()
    
    var cardNotOwnedInPromotionURL: [Int: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (deal != nil) {
            AddCardsView(deal: deal!)
            SetDealTitle(title: deal!.title!)
            if (deal!.rank != nil) {
                SetMedalImage(rank: deal!.rank!)
            }
            SetRewardValue(value: deal!.totalReward!)
            SetRewardDetail(deal: deal!)
        }
        
        CreateDataSection(deal: deal!)
        GetCardNotOwnedInPromotionURLFromDeal(deal: deal!)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240.0
    }
    
}

//
// MARK: - Set up Header Methor
//
extension DealDetailViewController
{
    func SetDeal(_ deal: Deal) {
        self.deal = deal
    }
    
    func AddCardsView(deal: Deal) {
        let cardsImageContainer = self.view.viewWithTag(100)
        
        enum CardPosition {
            case single
            case fore
            case middle
            case back
        }
        
        func AddCard(image: UIImage?, position: CardPosition, defaultCard: UIImage) {
            let cardView: UIImageView = UIImageView()
            if (image != nil) {
                cardView.image = image
            } else {
                cardView.image = defaultCard
            }
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.contentMode = .scaleAspectFit
            cardsImageContainer!.addSubview(cardView)
            if (position == .middle) {
                NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal,
                                   toItem: cardsImageContainer, attribute: .centerX,
                                   multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal,
                                   toItem: cardsImageContainer, attribute: .centerY,
                                   multiplier: 1.0, constant: 0.0).isActive = true
            } else {
                let attrX: NSLayoutAttribute = (position == .fore) ? .trailing : .leading
                let attrY: NSLayoutAttribute = (position == .fore) ? .bottom : .top
                NSLayoutConstraint(item: cardView, attribute: attrX, relatedBy: .equal,
                                   toItem: cardsImageContainer, attribute: attrX,
                                   multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: cardView, attribute: attrY, relatedBy: .equal,
                                   toItem: cardsImageContainer, attribute: attrY,
                                   multiplier: 1.0, constant: 0.0).isActive = true
            }
            let size: CGFloat = (position == .single) ? 1.0 : 0.8
            NSLayoutConstraint(item: cardView, attribute: .width, relatedBy: .equal,
                               toItem: cardsImageContainer, attribute: .width,
                               multiplier: size, constant: 0.0).isActive = true
            NSLayoutConstraint(item: cardView, attribute: .height, relatedBy: .equal,
                               toItem: cardsImageContainer, attribute: .height,
                               multiplier: size, constant: 0.0).isActive = true
        }
        
        if (cardsImageContainer != nil) {
            switch deal.totalStep! {
            case 1:
                // single card
                AddCard(image: deal.card?.image, position: .single,
                        defaultCard: #imageLiteral(resourceName: "mock_card_3"))
                break
            case 2:
                // back card
                AddCard(image: deal.Childs?.card?.image, position: .back,
                        defaultCard: #imageLiteral(resourceName: "mock_card_2"))
                // fore card
                AddCard(image: deal.card?.image, position: .fore, defaultCard: #imageLiteral(resourceName: "mock_card_3"))
                break
            case 3:
                // back card
                AddCard(image: #imageLiteral(resourceName: "mock_card_3"), position: .back, defaultCard: #imageLiteral(resourceName: "mock_card_3"))
                // middle card
                AddCard(image: #imageLiteral(resourceName: "mock_card_2"), position: .middle, defaultCard: #imageLiteral(resourceName: "mock_card_2"))
                // fore card
                AddCard(image: deal.card?.image, position: .fore, defaultCard: #imageLiteral(resourceName: "mock_card_3"))
                break
            default:
                break
            }
        }
    }
    
    func SetDealTitle(title: String) {
        if let titleLabel = view.viewWithTag(101) as? UILabel {
            titleLabel.text = title
        }
    }
    
    func SetMedalImage(rank: Int) {
        if let medalView = view.viewWithTag(102) as? UIImageView {
            switch rank {
            case 1:
                medalView.image = #imageLiteral(resourceName: "medal_gold")
                break
            case 2:
                medalView.image = #imageLiteral(resourceName: "medal_sliver")
                break
            case 3:
                medalView.image = #imageLiteral(resourceName: "medal_bronze")
                break
            default:
                medalView.image = nil
                break
            }
        }
    }
    
    func SetRewardValue(value: Float) {
        if let rewardValue = view.viewWithTag(103) as? UILabel {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            rewardValue.text = (formatter.string(from: NSNumber(value: value)) ?? "0") + " ฿"
        }
    }
    
    func SetRewardDetail(deal: Deal) {
        func CreateRewardItem(text: String, value: Float) -> UIView {
            let item = UIView()
            let label = UILabel()
            item.addSubview(label)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            label.text = "\(text) \(formatter.string(from: NSNumber(value: value))!)"
            label.font = label.font.withSize(10)
            
            let color = PrimoColor.Red.UIColor
            label.textColor = color
            
            item.layer.cornerRadius = 15
            item.layer.borderWidth = 2
            item.layer.borderColor = color.cgColor
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal,
                               toItem: item, attribute: .centerX,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal,
                               toItem: item, attribute: .centerY,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal,
                               toItem: item, attribute: .height,
                               multiplier: 1.0, constant: -10.0).isActive = true
            NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal,
                               toItem: item, attribute: .width,
                               multiplier: 1.0, constant: -20.0).isActive = true
            
            return item
        }
        
        func CreatePlusItem() -> UIView {
            let item = UIView()
            let plus = UIImageView(image: #imageLiteral(resourceName: "icon_plus"))
            plus.contentMode = .scaleAspectFit
            item.addSubview(plus)
            
            plus.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: plus, attribute: .centerX, relatedBy: .equal,
                               toItem: item, attribute: .centerX,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: plus, attribute: .centerY, relatedBy: .equal,
                               toItem: item, attribute: .centerY,
                               multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: plus, attribute: .height, relatedBy: .equal,
                               toItem: item, attribute: .height,
                               multiplier: 1.0, constant: -10.0).isActive = true
            NSLayoutConstraint(item: plus, attribute: .width, relatedBy: .equal,
                               toItem: item, attribute: .width,
                               multiplier: 1.0, constant: -10.0).isActive = true
            
            NSLayoutConstraint(item: plus, attribute: .width, relatedBy: .equal,
                               toItem: plus, attribute: .height,
                               multiplier: 1.0, constant: 0.0).isActive = true
            
            return item
        }
        
        if let rewardDetailContainer = view.viewWithTag(104) {
            var items: [UIView] = []
            var count = 0
            if (deal.comboDiscountAbs != nil && deal.comboDiscountAbs! > 0.0) {
                items.append(CreateRewardItem(text: RewardDetail.comboDiscountAbs.text,
                                              value: deal.comboDiscountAbs!))
                count += 1
            }
            if (deal.comboCreditAbs != nil && deal.comboCreditAbs! > 0.0) {
                if count > 0 {
                    items.append(CreatePlusItem())
                }
                items.append(CreateRewardItem(text: RewardDetail.comboCreditAbs.text,
                                              value: deal.comboCreditAbs!))
                count += 1
            }
            if (deal.comboVoucher != nil && deal.comboVoucher! > 0.0) {
                if count > 0 {
                    items.append(CreatePlusItem())
                }
                items.append(CreateRewardItem(text: RewardDetail.comboVoucher.text,
                                              value: deal.comboVoucher!))
                count += 1
            }
            for i in 0 ..< items.count {
                rewardDetailContainer.addSubview(items[i])
                items[i].translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: items[i], attribute: .height, relatedBy: .equal,
                                   toItem: rewardDetailContainer, attribute: .height,
                                   multiplier: 1.0, constant: 0.0).isActive = true
                NSLayoutConstraint(item: items[i], attribute: .top, relatedBy: .equal,
                                   toItem: rewardDetailContainer, attribute: .top,
                                   multiplier: 1.0, constant: 0.0).isActive = true
                if (i == 0) {
                    NSLayoutConstraint(item: items[i], attribute: .left, relatedBy: .equal,
                                       toItem: rewardDetailContainer, attribute: .left,
                                       multiplier: 1.0, constant: 0.0).isActive = true
                } else {
                    NSLayoutConstraint(item: items[i], attribute: .left, relatedBy: .equal,
                                       toItem: items[i - 1], attribute: .right,
                                       multiplier: 1.0, constant: 0.0).isActive = true
                }
            }
        }
    }
    
    func CreateDataSection(deal: Deal, index: Int = 1) {
        sections.append(Section(index: index, deal: deal, isCollapsed: true))
        if (deal.Childs != nil) {
            CreateDataSection(deal: deal.Childs!, index: index + 1)
        }
    }
    
    func GetCardNotOwnedInPromotionURLFromDeal(deal: Deal) {
        
        let myCards = CardDB.instance.getCards()
        var myCardsList: String = ""
        for card in myCards {
            myCardsList += "\(card.cardId)|"
        }
        let index = myCardsList.index(myCardsList.endIndex, offsetBy: -1)
        myCardsList = myCardsList.substring(to: index)
        print("Service.PromotionNotOwnedCard -> params:ownedCard -> [\(myCardsList)]")
        
        func GetCardNotOwnedInPromotionURL(deal: Deal) {
            let url = Service.PromotionNotOwnedCard.url
            let user = Service_User
            let pass = Service_Password
            let param: Parameters = [
                "promotion": deal.id!,
                "ownedCard": myCardsList,
                "inactive": "N"
            ]
            Alamofire.request(url, parameters: param)
                .authenticate(user: user, password: pass)
                .responseJSON { resonse in
                    switch resonse.result {
                    case .success(let value):
                        let json = JSON(value)
                        var cardUrls: [String] = []
                        for (_, subJson):(String, JSON) in json["data"] {
                            cardUrls.append(subJson["imgUrl"].stringValue)
                        }
                        self.cardNotOwnedInPromotionURL.updateValue(cardUrls, forKey: param["promotion"] as! Int)
                        print("Add cardNotOwnedInPromotionURL key: \(param["promotion"]!)")
                        break
                    case .failure(let error):
                        print(error)
                        PrimoAlert().Error()
                        break
                    }
            }
            if (deal.Childs != nil) {
                GetCardNotOwnedInPromotionURL(deal: deal.Childs!)
            }
        }
        
        GetCardNotOwnedInPromotionURL(deal: deal)
    }
    
}

//
// MARK: - Table Controller DataSource and Delegate
//
extension DealDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //
    // MARK: - Cell
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StepDetail") as? DealDetailTableViewCell {
            cell.howToLabel.text = sections[indexPath.section].howto
            cell.detailLabel.text = sections[indexPath.section].description
            cell.termLabel.text = sections[indexPath.section].term
            
            if (sections[indexPath.section].smsNumber.length > 0) {
                cell.SendSmsOrCommandButton.isHidden = false
                
                //Benz -Start 04-07-2017 Edited case check Send SMS and Send Code
                if (sections[indexPath.section].smsMsg[0] == "*") {
                    cell.SendSmsOrCommandButton.setTitle("SEND CODE", for: .normal)
                } else {
                    cell.SendSmsOrCommandButton.setTitle("SEND SMS", for: .normal)
                }
                //Benz -End- 04-07-2017
                
                cell.SendSmsOrCommandButton.addTarget(self, action: #selector(self.SendCodeOrSMS), for: .touchUpInside)
                cell.SendSmsOrCommandButton.smsMsg = sections[indexPath.section].smsMsg
                cell.SendSmsOrCommandButton.smsDesc = sections[indexPath.section].smsDesc
                cell.SendSmsOrCommandButton.smsNumber = sections[indexPath.section].smsNumber
            } else {
                cell.SendSmsOrCommandButton.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if sections[indexPath.section].collapsed { return }
        if let tableViewCell = cell as? DealDetailTableViewCell {
            tableViewCell.setCollectionViewDataSourceDelegate(self, proID: sections[indexPath.section].id)
            print("Section \(indexPath.section) = proID:\(sections[indexPath.section].id!)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].collapsed! ? 0 : UITableViewAutomaticDimension
    }
    
    //
    // MARK: - Section Header
    //
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.indexLabel.text = "\(sections[section].index!)"
        header.cardImageView.image = sections[section].cardImage
        header.titleLabel.text = sections[section].title
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        //Benz - 04-07-2017 Edited case sms and code
        if (sections[section].smsMsg.characters.count > 0) {
            if (sections[section].smsMsg[0] == "*") {
                header.warningLabel.text = "กดรหัสเพื่อรับสิทธิ์"
            } else {
                header.warningLabel.text = "ส่ง sms เพื่อรับสิทธิ์"
            }
            header.warningView.isHidden = false
        } else {
            header.warningView.isHidden = true
        }
        //Benz -End 04-07-2017
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 40.0
        if (sections[section].smsNumber.characters.count > 0) {
            height = 80.0
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

//
// MARK: - Section Header Delegate
//
extension DealDetailViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        for i in 0 ..< sections.count {
            sections[i].collapsed = true
        }
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        tableView.endUpdates()
        
        if collapsed {
            tableView.reloadData()
        }
    }
    
}

//
// MARK: - Collection
//
extension DealDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let proID = sections[section].id
        if let cardUrls = cardNotOwnedInPromotionURL[proID!] {
            return cardUrls.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherCardCell", for: indexPath) as! ImageCollectionViewCell
//        let proID = sections[indexPath.section].id
        let proID = collectionView.tag
        if let cardUrls: [String] = cardNotOwnedInPromotionURL[proID] {
            if (cardUrls.count > indexPath.row) {
                cell.cardImage.sd_setImage(with: URL(string: cardUrls[indexPath.row]),
                                           placeholderImage: #imageLiteral(resourceName: "mock_card_3"))
            }
        }
        
        return cell
    }
}

extension DealDetailViewController: MFMessageComposeViewControllerDelegate
{
    func SendCodeOrSMS(_ sender: Any) {
        let btn: SendSMSButton = sender as! SendSMSButton
        PrimoAlert().SmsDetail(desc: btn.smsDesc!) { (isOtherButton) -> Void in
            if (isOtherButton) {
                if (btn.smsMsg?[0] != "*") {
                    let messageVC = MFMessageComposeViewController()
                    
                    messageVC.body = "\(btn.smsMsg!)";
                    messageVC.recipients = ["\(btn.smsNumber!)"]
                    messageVC.messageComposeDelegate = self;
                    
                    self.present(messageVC, animated: false, completion: nil)
                } else {

               
//                    let numberPhone:String  = "telprompt://" + "%23"
//                    UIApplication.shared.openURL(NSURL(string : numberPhone)! as URL)
                    
                    
                    
                    let encodedHost = btn.smsNumber!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                   
                
                    if let url = URL(string: "tel://"+encodedHost!),
                        UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                    
       
              
//                    if let url = URL(string: "tel://\("")"), UIApplication.shared.canOpenURL(url) {
//                        if #available(iOS 10, *) {
//                            UIApplication.shared.open(url)
//                        } else {
//                            UIApplication.shared.openURL(url)
//                        }
//                    }
                    

                }

            }
        }
    }
    

    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
