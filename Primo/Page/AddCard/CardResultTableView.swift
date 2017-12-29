
import UIKit
import Alamofire
import SwiftyJSON

struct CardResult {
    var id: Int!
    var nameTH: String!
    var nameEN: String!
    var imageUrl: String!
    var inactive: Bool!
    var isAdded: Bool! = false
    
    init(json: JSON) {
        id = json["id"].intValue
        nameTH = json["name"].stringValue
        nameEN = json["nameEng"].stringValue
        imageUrl = json["imgUrl"].stringValue
        inactive = json["inactive"].boolValue
    }
}

class CardResultTableView: UITableView {

    var viewController: PageMenuViewController!
    
    var cardResultList: [CardResult] = []
    var cardDB: [PrimoCard] = []
    
    var cardType: Int = -1
    
    func SetUp(viewController: PageMenuViewController) {
        self.viewController = viewController
        self.delegate = self
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50.0
        
        GetCardDatabase()
    }
}

extension CardResultTableView
{
    func GetCardDatabase() {
        self.cardDB = CardDB.instance.getCards()
    }
    
    func LoadData(bankId: Int, cardType: Int, cardNetwork: Int) {
        LoadingOverlay.shared.showOverlay(view: viewController.view)
        
        self.cardType = cardType
        
        let url = Service.Card.url
        let user = Service_User
        let pass = Service_Password
        let param: Parameters = [
            "company": bankId,
            "type" : cardType,
            "cardNetwork" : cardNetwork
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
                    self.reloadData()
                    self.viewController.OnGotCardResult(count: self.cardResultList.count)
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

extension CardResultTableView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "CardResultCell", for: indexPath) as! CardResultTableCell
        
        cell.cardImage.sd_setImage(with: URL(string: cardResultList[indexPath.row].imageUrl))
        cell.nameTH.text = cardResultList[indexPath.row].nameTH
        cell.nameEN.text = cardResultList[indexPath.row].nameEN
        
        cell.checkBox.removeTarget(nil, action: nil, for: .allEvents)
        cell.checkBox.addTarget(self, action: #selector(OnCheck(_:)), for: .touchUpInside)
        cell.checkBox.tag = indexPath.row
        
        cell.checkBox.isSelected = cardResultList[indexPath.row].isAdded
        
        cell.checkBox.setImage(#imageLiteral(resourceName: "icon_check"), for: .selected)
        cell.checkBox.setImage(#imageLiteral(resourceName: "icon_uncheck"), for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
