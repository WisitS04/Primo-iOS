
import SwiftyJSON
struct BankDebit{
    var id: Int!
    var nameEN: String!
    var nameTH: String!
    var abbreviationEN: String!
    var abbreviationTH: String!
    var creditCount: Int!
    var debitCount: Int!
    var logoUrl: String!
    var seq: Int!
    
    init(json: JSON) {
        id = json["id"].intValue
        nameEN = json["nameEng"].stringValue
        nameTH = json["name"].stringValue
        abbreviationEN = json["abbreviationEng"].stringValue
        abbreviationTH = json["abbreviation"].stringValue
        creditCount = json["creditCount"].intValue
        debitCount = json["debitCount"].intValue
        logoUrl = json["logoUrl"].stringValue
        seq = json["seq"].intValue
    }
}
