
import UIKit

struct NewCard
{
    let id: Int64
    var cardId: Int64
    var type: PrimoCardType
    var nameEN: String
    var nameTH: String
    var imgUrl: String
    var image: UIImage?
    var point: Int?
    var pointToUse: Int?
    
    init(id: Int64, cardId: Int64, type: Int, nameEN: String, nameTH: String, imgUrl: String,
         point: Int? = nil , pointToUse: Int? = nil) {
        self.id = id
        self.cardId = cardId
        self.type = PrimoCardType(rawValue: type) ?? .unknown
        self.nameEN = nameEN
        self.nameTH = nameTH
        self.imgUrl = imgUrl
        self.point = point
        self.pointToUse = pointToUse
    }
}
