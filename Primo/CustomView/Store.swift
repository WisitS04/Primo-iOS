
import UIKit

class Store
{
    var storeId: Int64
    var branchId: Int64
    var storeName: String
    var storeNameEng: String
    var branchName: String
    var branchNameEng: String
    var imageUrl: String
    var distance: Int64
    

    init(storeId: Int64, branchId: Int64, storeName: String, storeNameEng: String,
         branchName: String, branchNameEng: String, imageUrl: String, distance: Int64) {
        
        self.storeId = storeId
        self.branchId = branchId
        self.storeName = storeName
        self.storeNameEng = storeNameEng
        self.branchName = branchName
        self.branchNameEng = branchNameEng
        self.imageUrl = imageUrl
        self.distance = distance

    }
}
