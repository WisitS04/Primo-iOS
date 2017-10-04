
class Deal {
    var pointMemberCard:Int = 0
    var pointCredite:Int = 0
    
    var isOwnedDeal: Bool? //is all own or not
    var totalStep: Int?
    
    var Childs: Deal?
    var card: PrimoCard?
    
    var id: Int?
    
    var rank: Int?
    var title: String? //static not from service
    
    var nameTh: String?
    var nameEn: String?
    var description: String?
    var termsAndConditions: String?
    
    var proName: String?
    
    var promotionTypeNameTh: String?
    var promotionTypeNameEn: String?
    var promotionCategoryName: String?
    
    var smsMsg: String?
    var smsDesc: String?
    var smsNumber: String?
    
    var cardImageUrl: String?
    
    var isDefaultCard: Bool?
    var isOwnedCard: Bool?
    var isPrimaryCard: Bool?
    
    var paymentMethodId: Int? //Null = all, 1 = full pay, 2 = installment
    
    var pointRequired: Int?
    
    var promotionTypeId: Int?
    
    var comboDiscountAbs: Float? // ส่วนลด
    var comboCreditAbs: Float? // เงินคืน
    var comboVoucher: Float? // บัตรกำนัล
    var specialMenu: Float? // เมนูพิเศษ
    var specialBeverage: Float? // เครื่องดื่มพิเศษ
    var gift: Float? // ของพรีเมียม
    
    var specialCondition: String!
    
    var comboCoupon: Float?
    
    var isStorewide: Bool?
    
    var totalReward: Float?
    
}
