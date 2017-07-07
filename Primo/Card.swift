import Foundation
import SwiftyJSON

class PrimoCard {
    let id: Int64
    var cardId: Int64
    var type: PrimoCardType
    var nameEN: String
    var nameTH: String
    var imgUrl: String
    var image: UIImage?
    var point: Int?
    
    init(id: Int64) {
        self.id = id
        cardId = -1
        type = .unknown
        nameEN = ""
        nameTH = ""
        imgUrl = ""
        point = nil
    }
    
    init(id: Int64, cardId: Int64, type: Int, nameEN: String, nameTH: String, imgUrl: String, point: Int? = nil) {
        self.id = id
        self.cardId = cardId
        self.type = PrimoCardType(rawValue: type) ?? .unknown
        self.nameEN = nameEN
        self.nameTH = nameTH
        self.imgUrl = imgUrl
        self.point = point
    }
    
    convenience init(json: JSON) {
        self.init(id: -2)
        json.forEach { (key, value) in
            switch key {
            case "id":
                self.cardId = value.int64Value
                break
            case "cardId":
                self.cardId = value.int64Value
                break
            case "cardTypeId":
                self.type = PrimoCardType(rawValue: value.intValue) ?? .unknown
                break
            case "name":
                self.nameTH = value.stringValue
                break
            case "nameEng":
                self.nameEN = value.stringValue
                break
            case "imgUrl":
                self.imgUrl = value.stringValue
                break
            case "pointToUse":
                self.point = value.int
                break
            default:
                break
            }
        }
    }
}

enum PrimoCardType: Int {
    case unknown = 0
    case creditCard = 1
    case debitCard = 2
    case eMoneyCard = 3
    case memberCard = 4
}
