
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CardTableView: UITableView
{
    var viewController: SelectCard!
    
    var cardResultList: [CardResult] = []
    var cardListFiter: [CardResult] = []
    
    var cardDB: [PrimoCard] = []
    
    var cardType: Int = -1
    var statusSearch: Bool = false
    
    func SetUp(viewController: SelectCard) {
        self.viewController = viewController
        self.delegate = self
        self.dataSource = self

        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50.0
         GetCardDatabase()
    }
}

extension CardTableView
{
    func GetCardDatabase() {
        self.cardDB = CardDB.instance.getCards()
    }
    
    func reciveDataFiter(list :[CardResult] , statusSearch: Bool){
//        cardListFiter.removeAll()
        self.statusSearch = statusSearch
        cardListFiter = list
    }
    
    func LoadData(bankId: Int, cardType: Int, cardNetwork: Int) {
        LoadingOverlay.shared.showOverlay(view: viewController.view)
        
        
        self.cardType = cardType
        
        let url = Service.Card.url
        let user = Service_User
        let pass = Service_Password
//        let param: Parameters = [
//            "company": bankId,
//            "type" : cardType,
//            "cardNetwork" : cardNetwork
//        ]

        let param: Parameters = [
            "company": bankId,
            "type" : cardType,
        ]
        
        Alamofire.request(url, parameters: param)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.cardResultList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        var cardResult = CardResult(json: subJson)
                        if (!cardResult.inactive) {
                            if self.cardDB.contains(where: { $0.cardId == Int64(cardResult.id) }) {
                                cardResult.isAdded = true
                            }
                            self.cardResultList.append(cardResult)
                        }
                    }
                    self.viewController!.OnSelectAllCard(list: self.cardResultList)
                    
                    self.reloadData()
//                    self.viewController.OnGotCardResult(count: self.cardResultList.count)
                    print("Call Card service success")
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                }
        }
    }
    
    
    
    func OnCheck(_ sender: Any) {
        if let btn = sender as? UIButton {
            btn.isSelected = !btn.isSelected
            if (btn.isSelected) {
                let card = cardResultList[btn.tag]
                let result = CardDB.instance.addCard(cId: Int64(card.id),
                                                     cType: cardType,
                                                     cNameTH: card.nameTH,
                                                     cNameEN: card.nameEN,
                                                     cImgUrl: card.imageUrl)
                print("OnCheck add card result: \(result)")
                if (result != -1) {
                    cardResultList[btn.tag].isAdded = true
                    GetCardDatabase()
                }
            } else {
                let card = cardResultList[btn.tag]
                let result = CardDB.instance.deleteCard(cId: Int64(card.id))
                print("OnCheck delete card result: \(result)")
                if (result) {
                    cardResultList[btn.tag].isAdded = false
                    GetCardDatabase()
                }
            }
        }
    }
    
    
}


extension CardTableView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(statusSearch){
            return cardListFiter.count
        }
        return cardResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "CardResultCell", for: indexPath) as! SelectCardCell
        
        
        if(statusSearch){
            
            cell.card_img.sd_setImage(with: URL(string: cardListFiter[indexPath.row].imageUrl))
            cell.name_card.text = cardListFiter[indexPath.row].nameTH
            cell.subname_card.text = cardListFiter[indexPath.row].nameEN
            
            cell.select_card_checkbox.removeTarget(nil, action: nil, for: .allEvents)
            cell.select_card_checkbox.addTarget(self, action: #selector(OnCheck(_:)), for: .touchUpInside)
            cell.select_card_checkbox.tag = indexPath.row
            
            cell.select_card_checkbox.isSelected = cardListFiter[indexPath.row].isAdded
            
            cell.select_card_checkbox.setImage(#imageLiteral(resourceName: "icon_check"), for: .selected)
            cell.select_card_checkbox.setImage(#imageLiteral(resourceName: "icon_uncheck"), for: .normal)
            
        }else{
            cell.card_img.sd_setImage(with: URL(string: cardResultList[indexPath.row].imageUrl))
            cell.name_card.text = cardResultList[indexPath.row].nameTH
            cell.subname_card.text = cardResultList[indexPath.row].nameEN
            
            cell.select_card_checkbox.removeTarget(nil, action: nil, for: .allEvents)
            cell.select_card_checkbox.addTarget(self, action: #selector(OnCheck(_:)), for: .touchUpInside)
            cell.select_card_checkbox.tag = indexPath.row
            
            cell.select_card_checkbox.isSelected = cardResultList[indexPath.row].isAdded
            
            cell.select_card_checkbox.setImage(#imageLiteral(resourceName: "icon_check"), for: .selected)
            cell.select_card_checkbox.setImage(#imageLiteral(resourceName: "icon_uncheck"), for: .normal)
        }
        
   
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
