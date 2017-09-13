
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class BankListCollectionView: UICollectionView
{
    var viewController: AddCardController?
    var bankList: [Bank] = []
    
    var crediteBankList: [Bank] = []
    var debiteBankList: [Bank] = []
    var companyList: [Bank] = []
    var typeSelect : Int = 1
    func SetUp(viewController: AddCardController) {
        self.viewController = viewController
        self.delegate = self
        self.dataSource = self
        BankSelectIndex =  IndexPath(item: -1, section: -1)
    }
    
}


extension BankListCollectionView
{
    
    func LoadBankList(cardType: Int) {
        LoadingOverlay.shared.showOverlay(view: self.superview!)
        
        var url = Service.Banks.url
        let user = Service_User
        let pass = Service_Password
        let param: Parameters = [ "cardType": cardType ]
        
        if(cardType == PrimoCardType.memberCard.rawValue){
            url = Service.Company.url
        }
        
        Alamofire.request(url, parameters: param)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.bankList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let bank = Bank(json: subJson)
                        self.bankList.append(bank)
                        //print("Add bank \(bank.abbreviationTH!) \nURL: \(bank.logoUrl!)")
                    }
                    self.reloadData()
                    print("Call Banks service success")
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                }
        }
        
    }
    
    
    func CallCrediteBank(){
        LoadingOverlay.shared.showOverlay(view: self.superview!)
        
        let url = Service.Banks.url
        let user = Service_User
        let pass = Service_Password
        let cardType: Int = 1
        let param: Parameters = [ "cardType": cardType ]
        Alamofire.request(url, parameters: param)

            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    self.bankList.removeAll()
                    self.crediteBankList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let bank = Bank(json: subJson)
//                        self.bankList.append(bank)
                        self.crediteBankList.append(bank)
                        //print("Add bank \(bank.abbreviationTH!) \nURL: \(bank.logoUrl!)")
                    }
                     print("Call Banks credite service success")
                     self.CallDebitBank()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func CallDebitBank(){
        let url = Service.Banks.url
        let user = Service_User
        let pass = Service_Password
        let cardType: Int = 2
        let param: Parameters = [ "cardType": cardType ]
        
        
        
        Alamofire.request(url, parameters: param)
            
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.debiteBankList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let bank = Bank(json: subJson)
//                        self.bankList.append(bank)
                        self.debiteBankList.append(bank)
                    }
                    print("Call Banks debit service success")
                    self.CallCompany()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func CallCompany(){
        let cardType: Int = 4
        let url = Service.Company.url
        let user = Service_User
        let pass = Service_Password
        let param: Parameters = [ "cardType": cardType ]
  
        Alamofire.request(url, parameters: param)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.companyList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let company = Bank(json: subJson)
//                        self.bankList.append(bank)
                        self.companyList.append(company)
                        //print("Add bank \(bank.abbreviationTH!) \nURL: \(bank.logoUrl!)")
                    }
                    self.reloadData()
                    print("Call Company service success")
                    self.viewController!.finishCallService()
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func SelectBankTypeAndCompany(cardType: Int){
        typeSelect = cardType
        if(!crediteBankList.isEmpty || !debiteBankList.isEmpty || !companyList.isEmpty){
            self.reloadData()
        }
    
    }

}



extension BankListCollectionView: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countCell: Int = 1
        if(typeSelect == PrimoCardType.creditCard.rawValue){
            countCell = crediteBankList.count
        }else if (typeSelect == PrimoCardType.debitCard.rawValue){
             countCell = debiteBankList.count
        }else{
             countCell = companyList.count
        }
        return countCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankCell", for: indexPath) as! ImageCollectionViewCell
        
        if(typeSelect == PrimoCardType.creditCard.rawValue ){
            
           cell.cardImage.sd_setImage(with: URL(string: crediteBankList[indexPath.row].logoUrl))
           cell.NameBank.text = crediteBankList[indexPath.row].nameEN
            
        }else if(typeSelect == PrimoCardType.debitCard.rawValue){
            cell.cardImage.sd_setImage(with: URL(string: debiteBankList[indexPath.row].logoUrl))
            cell.NameBank.text = debiteBankList[indexPath.row].nameEN

        }else{
            cell.cardImage.sd_setImage(with: URL(string: companyList[indexPath.row].logoUrl))
            cell.NameBank.text = companyList[indexPath.row].nameEN

        }
        
        
//        if(BankSelectIndex.item != -1 && BankSelectIndex.section != -1){
//            if(BankSelectIndex != indexPath){
//                cell.statusImage.image = UIImage(named: "buttongrey")
//            }else{
//                cell.statusImage.image = UIImage(named: "button_check")
//            }
//        }else{
//            cell.statusImage.image = nil
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (viewController != nil) {

            if(typeSelect == PrimoCardType.creditCard.rawValue ){
                self.viewController!.OnBankSelected(id: crediteBankList[indexPath.row].id)
            }else if(typeSelect == PrimoCardType.debitCard.rawValue){
                self.viewController!.OnBankSelected(id: debiteBankList[indexPath.row].id)
            }else{
                self.viewController!.OnBankSelected(id: companyList[indexPath.row].id)
            }
            

//            BankSelectIndex = indexPath
//            collectionView.reloadData()
//            
        }
    }
    
    
}


    
