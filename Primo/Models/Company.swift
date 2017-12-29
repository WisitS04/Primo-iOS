
import SwiftyJSON

struct CompanyMemberCard{
    var id: Int!
    var nameEN: String!
    var nameTH: String!
    var abbreviationEN: String!
    var abbreviationTH: String!
    var creditCount: Int!
    var debitCount: Int!
    var logoUrl: String!
    var seq: Int!
    var typeId: Int!
    var typeName: String!
    var typeNameEng: String!
    
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
        typeId = json["typeId"].intValue
        typeName = json["typeName"].stringValue
        typeNameEng = json["typeNameEng"].stringValue
    }
}
