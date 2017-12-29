/////////////
// Service //
/////////////
enum Service: String {
    //case Banks = "Banks"
    //case Card = "Card"
    //case CardNetword = "CardNetword"
    case FindStoreDetailNearBy = "FindStoreDetailNearBy"
    case Department = "Department"
    case RestaurantPrice = "RestaurantPrice" 
    case DealsPromotion = "DealsPromotion"
    case PromotionNotOwnedCard = "PromotionNotOwnedCard"
    case Banks = "Banks"
    case Card = "Card"
    case CardNetwork = "CardNetwork"
    case Company = "Company"
    case DataVersion = "DataVersions"
    case CardByIdList = "CardByIdList"
    
    
    var url: String {
        return Service_Url + self.rawValue
    }
}
//let Service_Url = "http://primovmset.southeastasia.cloudapp.azure.com/PrimoCustomerService/"
let Service_Url = "https://primoservice.co/PrimoCustomerService/"
let Service_User = "anonymous" // "abc@abc.com"
let Service_Password = "spoton-primo" // "Cust-2014"

enum CardType: Int {
    case Credit = 1
    case Debit = 2
    
    var toString: String {
        var value = ""
        switch self.rawValue {
        case 1:
            value = "Credit"
        case 2:
            value = "Debit"
        default:
            value = ""
        }
        return value
    }
}

///////////////////
//IndexSelectBank//
///////////////////
var BankSelectIndex: IndexPath =  IndexPath(item: -1, section: -1)


///////////////////
///KEY Guide App///
///////////////////

var KEYGuideNeayBy: String = "KEYNEAYBY"
var VersionGuideNearby = UserDefaults.standard

var KEYGuideAddCard: String = "KEYADDCARD"
var VersionGuideAddCard = UserDefaults.standard

var KEYGuideDetail: String = "KEYDETAIL"
var VersionGuideDetail = UserDefaults.standard

var KEYGuideNotDepDetail: String = "KEYDETAILNotDep"
var VersionGuideDetailNotDep = UserDefaults.standard


var KEYGuideDeals: String = "KEYDEALS"
var VersionGuideDeals = UserDefaults.standard


//////////////////////////
///Data Version Service///
//////////////////////////
var KEYDataVersion: String = "KEYDataVersion"
var DataVersionNumber = UserDefaults.standard


/////////////////////
///KEY APP Version///
/////////////////////
var cerrentVersin: Double = 11.2 //version show guide app is 1.1.2


/////////////////////////////////
///KEY APP Version Walkthrough///
/////////////////////////////////
var KEYAppVersion: String = "KEYAPPVERSION"
var VersionNumber = UserDefaults.standard



///////////////////
//Key Versuin DB///
///////////////////
var MyCardDB: String =  "KEYMYCARDDATABASE"
var KEYStoreDB: String = "KEYSTOREDATABASE"


//////////////
//DB Version//
//////////////
var DataBaseVersionCard = UserDefaults.standard
var DataBaseVersionStore = UserDefaults.standard

/////////////
// Locaion //
/////////////
struct Location {
    var lat: Float
    var long: Float
    
    init(lat: Float, long: Float) {
        self.lat = lat
        self.long = long
    }
}
let spotonBangkokLocation = Location(lat: 13.7292169, long: 100.529216)
let spotonPhuketLocation = Location(lat: 7.874834, long: 98.363178)
let btsSiam = Location(lat: 13.7457426, long: 100.5341965)

//////////////////
// Key Location //
//////////////////
let KEYLAT:String = "KEYLAT"
let KEYLONG:String = "KEYLONG"


//Fisrt Run
let KEYFIRSTRUN:String = "KEYFIRSTRUN"


//Click Cancel Loop GPS
let KEYCABCELLOOPGPS: String = "KEYCABCELLOOPGPS"
var isClieckCancelLoopGPS = UserDefaults.standard


////////////////////////////
// Deal Page: Static Text //
////////////////////////////
enum DealPage: String {
    case UnderCardText_OwnedDeal = "บัตรของคุณ"
    case UnderCardText_NotOwn = "คุณยังไม่มีบัตรนี้"
    case DealTitle = "โปรโมชั่น %d ต่อ" //"ใช้ %d บัตร เพื่อรับสิทธิประโยชน์"
}

enum RewardDetail: String {
    case comboDiscountAbs = "ส่วนลด"
    case comboCreditAbs = "เงินคืน"
    case comboVoucher = "บัตรกำนัล"
    case specialMenu = "เมนูพิเศษ"
    case specialBeverage = "เครื่องดื่มพิเศษ"
    case gift = "ของพรีเมียม"
    
    var text: String {
        return self.rawValue
    }
}

enum PrimoColor: String {
    case Green = "#3FBCA4"
    case Red = "#BE293B"
    case Orange = "#F4744D"
    case Smoke = "#CCCCCC"
    case greenNew = "#46BCA4"
    
    var UIColor: UIColor {
        return HexStringToUIColor(hex: self.rawValue)
    }
}
