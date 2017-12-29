


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage



class MyCard_ViewController: UITableViewController
{
    var newCard: [PrimoCard] = []
    
    @IBOutlet var MyCardTable: MyCard_TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        checkDataVertion()
//        checkVersionCard()
        
        
         self.navigationController?.navigationBar.isTranslucent = false
        _ = CardDB.instance.CheckVertionCardDB()

        
        MyCardTable.allowsSelection = false
        MyCardTable.Setup(tableType: .memberCard ,mView: self.view)
    }
    

}

extension MyCard_ViewController {
    
    func checkDataVertion(){
        
        let dataVersion: Double = DataVersionNumber.double(forKey: KEYDataVersion)
        
        LoadingOverlay.shared.showOverlay(view: self.view)
        let url = Service.DataVersion.url
        let user = Service_User
        let pass = Service_Password
        
        Alamofire.request(url)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_, subJson):(String, JSON) in json{
                
                    
                    if(subJson["name"].stringValue == "Card"){
                        let version = subJson["version"].doubleValue

                        if(version != dataVersion){
                            self.checkVersionCard()
                            DataVersionNumber.set(version,forKey: KEYDataVersion)
                        }
                    }
    
                    
                }
                
                
                print("Call Banks service success")
                LoadingOverlay.shared.hideOverlayView()
            case .failure(let error):
                print(error)
                LoadingOverlay.shared.hideOverlayView()
            }
        }
    }
    
    
    
    func checkVersionCard(){
        LoadingOverlay.shared.showOverlay(view: self.view)
        let Mycard: String = CheckMyCard()

        
        self.newCard = CardDB.instance.getCards()

    
        
        let url = URL(string: Service.CardByIdList.url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic YW5vbnltb3VzOnNwb3Rvbi1wcmltbw==", forHTTPHeaderField: "authorization")
        request.httpMethod = "POST"
        let postString = Mycard
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                LoadingOverlay.shared.hideOverlayView()

                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                LoadingOverlay.shared.hideOverlayView()

            }
            
            if(!data.isEmpty){
                let json = JSON(data)
                for (_, subJson):(String, JSON) in json["data"] {
                    
                    for item in self.newCard {
                        
                        let mId = subJson["id"].int64
                        
                        if(item.cardId == mId){
                            let nameTH = subJson["name"].stringValue
                            let nameEN = subJson["nameEng"].stringValue
                            let imageUrl = subJson["imgUrl"].stringValue
                            
                            let newMyCard = PrimoCard(id: item.id,
                                                      cardId: item.cardId,
                                                      type: item.type.rawValue,
                                                      nameEN: nameEN,
                                                      nameTH: nameTH,
                                                      imgUrl: imageUrl,
                                                      point: item.point,
                                                      pointToUse: item.pointToUse)
                            
                            _ = CardDB.instance.updateCard(cId: mId!, newCard: newMyCard)
                        }
                    }
                    
            
                    
                }
                LoadingOverlay.shared.hideOverlayView()
            }else{
                LoadingOverlay.shared.hideOverlayView()
            }
          
   
        }
        task.resume()
    }
    
    
 
    
    func CheckMyCard() -> String{
        var result: String = ""
        self.newCard = CardDB.instance.getCards()
        
        for item in self.newCard{
            result = "\(result)\(item.cardId)\(",")"
            
        }
        
        if(result.length > 0){
            let index = result.index(result.startIndex, offsetBy: result.length-1)
            result = result.substring(to: index)
        }
        result = "\("[") \(result) \("]")"
        return result
        
    }
    
}
