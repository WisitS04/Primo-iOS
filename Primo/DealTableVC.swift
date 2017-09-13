
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class DealTableVC: UITableViewController
{
//    var dealList: [Deal] = []
    
    var dealsWithInstallment: [Deal] = []
    var dealsWithoutInstallment: [Deal] = []
    
    
    
    
    var isGotDealsWithInstallment: Bool = false
    var isGotDealsWithoutInstallment: Bool = false
    
//    var dealItems: [[Deal]] = [[],[],[]]
//    var filteredDeals: [Deal] = []
    var dealBuffer: [Deal] = []
    
    var controllrtDeals: DealViewController? = nil
    var date: String = ""
    var price: Int = 0
    var store: Int = 0
    var branch: Int = 0
    var departmentId: Int = 0
    
    var isUsePoint: Bool = false
    var isInstallment: Bool = false
    var isPeyment: Bool = false
    var isUnPoint: Bool = false
    
    var pointToCrediteCard : Int = 0
    var pointToMemberCard : Int = 0
    
    let sectionTitle = ["คุ้มที่สุด",
                        "คุ้มที่สุดสำหรับคุณ",
                        "ทางเลือกอื่น"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return sectionTitle.count
//    }
//    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle[section]
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dealItems[section].count
        return dealBuffer.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let deal = self.dealItems[indexPath.section][indexPath.row]
        let deal = dealBuffer[indexPath.row]
        
        if (deal.totalStep! == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell_OneStep",
                                                     for: indexPath) as! DealCell_OneStep
            cell.SetData(deal: deal,mControllerForDeals :controllrtDeals!)
            return cell
        } else if (deal.totalStep! == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell_TwoStep",
                                                     for: indexPath) as! DealCell_TwoStep
            cell.SetData(deal: deal,mControllerForDeals :controllrtDeals!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell_ThreeStep",
                                                     for: indexPath) as! DealCell_ThreeStep
            cell.SetData(deal: deal,mControllerForDeals :controllrtDeals!)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let motherView = self.parent as? DealViewController {
//            let deal = self.dealItems[indexPath.section][indexPath.row]
            let deal = dealBuffer[indexPath.row]
            motherView.OnDealSelected(deal)
        }
    }
}

extension DealTableVC
{
    
    func UpdateData(usePoint: Bool = false,
                    installment: Bool = false,
                    Peyment: Bool = false,
                    UnPoint: Bool  ,
                    callWS: Bool = true ,
                    editePoint: Bool = false,
                    mCard:  [PrimoCard]) {
        
        isUsePoint = usePoint
        isInstallment = installment
        isPeyment = Peyment
        isUnPoint = UnPoint
        
        if (callWS) {
            CallWebservice(statusEditePoint: editePoint, Card: mCard)
        } else {
            FilterDeal()
        }
    }
    
    func CallWebservice(statusEditePoint :Bool = false , Card: [PrimoCard]) {
        LoadingOverlay.shared.showOverlay(view: self.view)
        //
        // Parameters
        //
        var param: Parameters = [
            "date": date,
            "isDealsOwnedCardOnly": true,
            "installment": 0, // 0 = false | 1 = true
            "price": price,
            "store": store,
            "branch" : branch
        ]
        if (departmentId > 0) {
            param["dept"] = departmentId
        }
        let cards = CardDB.instance.getCards()
        if (cards.count > 0) {
            param["ownedCardList"] = GenServiceParam(ownedCardList: cards, EditePoint: statusEditePoint, card: Card)
        }
        //
        // Get dealsWithoutInstallment
        //
        isGotDealsWithoutInstallment = false
        Alamofire.request(Service.DealsPromotion.url + "?pagesize=20&page=1",
                          method: .post,
                          parameters: param,
                          encoding: JSONEncoding.default)
            .authenticate(user: Service_User, password: Service_Password)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.dealsWithoutInstallment.removeAll()
                    self.dealsWithoutInstallment = self.CreateDealList(json)
                    self.isGotDealsWithoutInstallment = true
                    self.OnCallDealsPromotionServiceSuccess()
                    print("Call DealsPromotion service [Without Installment] -> success")
                case .failure(let error):
                    print(error)
                    self.OnCallDealsPromotionServiceSuccess(isError: true)
                }
        }
        //
        // Get dealsWithInstallment
        //
        param["installment"] = 1
        isGotDealsWithInstallment = false
        Alamofire.request(Service.DealsPromotion.url + "?pagesize=20&page=1",
                          method: .post,
                          parameters: param,
                          encoding: JSONEncoding.default)
            .authenticate(user: Service_User, password: Service_Password)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.dealsWithInstallment.removeAll()
                    self.dealsWithInstallment = self.CreateDealList(json)
                    self.isGotDealsWithInstallment = true
                    self.OnCallDealsPromotionServiceSuccess()
                    print("Call DealsPromotion service [With Installment] -> success")
                case .failure(let error):
                    print(error)
                    self.OnCallDealsPromotionServiceSuccess(isError: true)
                }
        }
    }
    
    func OnCallDealsPromotionServiceSuccess(isError: Bool = false) {
        if (isGotDealsWithoutInstallment && isGotDealsWithInstallment) {
            FilterDeal()
            LoadingOverlay.shared.hideOverlayView()
        }
        if isError {
            PrimoAlert().Error()
        }
    }
    
    func CreateDealList(_ dealJson: JSON) -> [Deal] {
        var result: [Deal] = []
        for (_, subJson):(String, JSON) in dealJson["data"]
        {
            result.append(CreateDeal(json: subJson))
        }
        return result
    }
    
    func CreateDeal(json: JSON) -> Deal {
        let deal: Deal = Deal()
        
        deal.id = json["id"].intValue
        
        deal.nameEn = json["nameEng"].stringValue
        deal.nameTh = json["name"].stringValue
        deal.description = json["description"].stringValue
        deal.termsAndConditions = json["termsAndConditions"].stringValue
        
        deal.proName = json["proName"].stringValue
        
        deal.promotionTypeNameEn = json["promotionTypeNameEng"].stringValue
        deal.promotionTypeNameTh = json["promotionTypeName"].stringValue
        deal.promotionCategoryName = json["promotionCategoryName"].stringValue
        
        deal.smsMsg = json["smsMsg"].stringValue
        deal.smsDesc = json["smsDesc"].stringValue
        deal.smsNumber = json["smsNumber"].stringValue
        
        deal.card = PrimoCard(json: json["card"])
        
        deal.isOwnedCard = json["isOwnedCard"].boolValue
        deal.isDefaultCard = json["isDefaultCard"].boolValue
        deal.isPrimaryCard = json["isPrimaryCard"].boolValue
        
        deal.paymentMethodId = json["paymentMethodId"].intValue
        
        deal.pointRequired = json["pointRequired"].intValue
        
        deal.comboCoupon = json["comboCoupon"].floatValue
        deal.comboVoucher = json["comboVoucher"].floatValue
        deal.comboCreditAbs = json["comboCreditAbs"].floatValue
        deal.comboDiscountAbs = json["comboDiscountAbs"].floatValue
        
        deal.totalReward = json["totalReward"].floatValue
        
        if (!json["child"].isEmpty) {
            deal.Childs = CreateDeal(json: json["child"])
        }
        
        return deal
    }
    
    func FilterDeal() {
        var deals: [Deal] = []
        let source: [Deal] = isInstallment ? dealsWithInstallment : dealsWithoutInstallment
        
        for deal: Deal in source {
            if CheckDealCase(deal: deal) {
                deals.append(deal)
            }
        }
        FilterDealForDisplay(deals)
        
        // if use point, get max point from deal if point in DB is null
        if isUsePoint {
            let myCardList = CardDB.instance.getCards()
            for card in myCardList {
                if (card.point == nil) {
                    card.point = GetMaxPoint(cardId: card.cardId)
//                    print("\(card.nameTH) max point = \(card.point!)")
                }
            }
            if let motherView = self.parent as? DealViewController {
                motherView.UpdateCardData(cardList: myCardList)
            }
        }
        
        self.tableView.reloadData()
        print("tableView.reloadData()")
    }
    
    func CheckDealCase(deal: Deal, usePointCase: Bool = false, installmentCase: Bool = false ) -> Bool {
        
        var result = false
        var point = usePointCase
        var installment = installmentCase

        if (deal.promotionCategoryName! == "Point Redemption") {
            point = true
        }
        if (deal.paymentMethodId! == 2) {
            installment = true
        }
        
        if (deal.Childs != nil) {
            return CheckDealCase(deal: deal.Childs!, usePointCase: point, installmentCase: installment)
        } else {
            
            if(isPeyment && !isInstallment && isUsePoint && !isUnPoint && point && !installment){
                result = true

            }else if(isPeyment && !isInstallment && !isUsePoint && isUnPoint && !installment && !point){
                result = true

            }else if(!isPeyment && isInstallment && isUsePoint && !isUnPoint && point && installment){
                result = true

            }else if(!isPeyment && isInstallment && !isUsePoint && isUnPoint && !point && installment){
                result = true

            }
            
            
//            if (isUsePoint && isInstallment && point && installment) {
//                // Use point and Installment
//                result = true
//            } else if (isUsePoint && !isInstallment && point && !installment) {
//                // Use point only
//                result = true
//            } else if (!isUsePoint && isInstallment && !point && installment) {
//                // Installment only
//                result = true
//            } else if (!isUsePoint && !isInstallment && !point && !installment) {
//                // Not use point and Not installment
//                result = true
//            }
        }
        
        return result
    }
    
    func FilterDealForDisplay(_ deals: [Deal]) {
//        dealItems.removeAll()
//        dealItems = [[],[],[]]
//        filteredDeals.removeAll()
        dealBuffer.removeAll()
        var TitleDeal: String!
        
        // คุ้มที่สุด
        let topDeal = deals.prefix(3)
//        dealItems[0] = Array(topDeal)
        for i in 0 ..< topDeal.count {
            topDeal[i].rank = i + 1
        }
        
        for deal: Deal in deals {
//            deal.isOwnedDeal = IsThisMyDeal(deal: deal)
            deal.isOwnedDeal = true
//            if (deal.isOwnedDeal!) {
//                // คุ้มที่สุดสำหรับคุณ
//                dealItems[1].append(deal)
//            } else {
//                // ทางเลือกอื่น
//                dealItems[2].append(deal)
//            }
            dealBuffer.append(deal)
            
            pointToMemberCard = 0
            pointToCrediteCard = 0
            
            AddPoin(deal: deal)
            deal.pointCredite = pointToCrediteCard
            deal.pointMemberCard = pointToMemberCard
            

            deal.totalStep = GetTotalStep(deal: deal)
            TitleDeal = String(format: DealPage.DealTitle.rawValue, deal.totalStep ?? 0)
            
            if(deal.isOwnedCard)!{
//                TitleDeal = ("บัตรของคุณ\n" + TitleDeal)
                 TitleDeal = (TitleDeal+"")
            }else{
                TitleDeal = (TitleDeal+"")
            }
//            deal.title = String(format: DealPage.DealTitle.rawValue, deal.totalStep ?? 0)
            deal.title = TitleDeal
        }
    }
    
    func IsThisMyDeal(deal: Deal) -> Bool {
        if (deal.Childs != nil && deal.isOwnedCard!) {
            return IsThisMyDeal(deal: deal.Childs!)
        }
        return deal.isOwnedCard!
    }
    

    func AddPoin(deal: Deal){

        
        if(deal.card?.type == .memberCard){
            pointToMemberCard += (deal.card?.point ?? 0)
        }else{
            pointToCrediteCard = pointToCrediteCard + (deal.card?.point ?? 0)
            
        }
        if(deal.Childs != nil){
            return AddPoin(deal: deal.Childs!)
        }
    }
    
    func GetTotalStep(deal: Deal, count: Int = 1) -> Int {
        if (deal.Childs != nil) {
            
            return GetTotalStep(deal: deal.Childs!, count: count + 1)
        }
        return count
    }
    
    func GetMaxPoint(cardId id: Int64) -> Int {
        var maxPoint: Int = 0
//        let allCurrentDeals = dealItems[1] + dealItems[2]
//        for deal in allCurrentDeals {
        for deal in dealBuffer {
            maxPoint = GetMaxPoint(cardId: id, deal: deal, point: maxPoint)
        }
        return maxPoint
    }
    
    private func GetMaxPoint(cardId id: Int64, deal: Deal, point: Int) -> Int {
        var maxPoint = point
        if (deal.card?.cardId == id) {
            maxPoint = max(point, deal.card!.point!)
        }
        if (deal.Childs != nil) {
            return GetMaxPoint(cardId: id, deal: deal.Childs!, point: maxPoint)
        }
        return maxPoint
    }
}
