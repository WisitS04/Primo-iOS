import UIKit

class RestaurantPrice
{
    
    //Dep
    var id: Int64?
    var name: String?
    
    //RestaurantPrice
    var branchId: Int64?
    var branchName: String?
    var branchNameEng: String?
    var brandId: Int64?
    var brandName: String?
    var brandNameEng: String?
    var lowerPrice: Int?
    var middlePrice: Int?
    var storeDetailId: Int64?
    var storeId: Int64?
    var storeName: String?
    var storeNameEng: String?
    var storeTypeId: Int64?
    var storeTypeName: String?
    var storeTypeNameEng: String?
    var upperPrice: Int?
    
    
    init(id: Int64? = 0, name: String? = "",branchId: Int64? = 0, branchName: String? = "", branchNameEng: String? = "", brandId: Int64? = 0,
         brandName: String? = "", brandNameEng: String? = "",
         lowerPrice: Int? = 0, middlePrice: Int? = 0, storeDetailId: Int64? = 0, storeId: Int64? = 0,
         storeName: String? = "", storeNameEng: String? = "", storeTypeId: Int64? = 0, storeTypeName: String? = "",
         storeTypeNameEng: String? = "", upperPrice: Int? = 0) {
        
        self.id = id
        self.name = name
        
        
        self.branchId = branchId
        self.branchName =  branchName
        self.branchNameEng = branchNameEng
        self.brandId = brandId
        self.brandName = brandName
        self.brandNameEng = brandNameEng
        self.lowerPrice = lowerPrice
        self.middlePrice = middlePrice
        self.storeDetailId = storeDetailId
        self.storeId = storeId
        self.storeName = storeName
        self.storeNameEng = storeNameEng
        self.storeTypeId = storeTypeId
        self.storeTypeName = storeTypeName
        self.storeTypeNameEng = storeTypeNameEng
        self.upperPrice = upperPrice
    }
}
