
import UIKit

class notificationModel
{
    var notificationId: Int64
    var titleName: String
    var subTitleName: String
    var imageUrl: String
    var type: Int
    
    init(notificationId: Int64,imageUrl: String, titleName: String, subTitleName: String, type: Int) {
        
        self.notificationId = notificationId
        self.titleName = titleName
        self.subTitleName = subTitleName
        self.imageUrl = imageUrl
        self.type = type
        
    }
}
