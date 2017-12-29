
import UIKit

struct Place
{
    var storeId: Int
    var branchId: Int
    
    var nameTH: String
    var nameEN: String
    var distance: Int
    
    var imageUrl: String
    
    var storeTypeId: Int?
    
    init(storeId: Int, branchId: Int, nameTH: String, nameEN: String, distance: Int, imageUrl: String, storeTypeId: Int? = nil) {
        self.storeId = storeId
        self.branchId = branchId
        self.nameTH = nameTH
        self.nameEN = nameEN
        self.distance = distance
        self.imageUrl = imageUrl
        self.storeTypeId = storeTypeId
    }
}
