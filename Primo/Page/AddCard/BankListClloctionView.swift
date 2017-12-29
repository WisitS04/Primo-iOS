
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
    var versionGuideAddCard: Double = 0.00

    var isDisableInternet:Bool = false
    
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
                        let bank = Bank(json: subJson, mCardType: cardType)
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
        CheckReachabilityStatus()
        if(!isDisableInternet){
            
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
                            let bank = Bank(json: subJson, mCardType: 1)
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

    }
    
    func CallDebitBank(){
        let url = Service.Banks.url
        let user = Service_User
        let pass = Service_Password
        let cardType: Int = 2
        let param: Parameters = [ "cardType": cardType]
        
        
        
        Alamofire.request(url, parameters: param)
            
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.debiteBankList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let bank = Bank(json: subJson, mCardType: 2)
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
        let param: Parameters = [ "cardType": cardType,
                                  "Inactive": 0]
  
        Alamofire.request(url, parameters: param)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.companyList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let company = Bank(json: subJson, mCardType: 4)
//                        self.bankList.append(bank)
                        self.companyList.append(company)
                        //print("Add bank \(bank.abbreviationTH!) \nURL: \(bank.logoUrl!)")
                    }
                    self.reloadData()
                    print("Call Company service success")
                    self.CallCompanyE_MoneyCard()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func CallCompanyE_MoneyCard(){
        let cardType: Int = 3
        let url = Service.Company.url
        let user = Service_User
        let pass = Service_Password
        let param: Parameters = [ "cardType": 3,
                                  "Inactive": 0]
        
        Alamofire.request(url, parameters: param)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    self.companyList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let company = Bank(json: subJson, mCardType: cardType)
                        //                        self.bankList.append(bank)
                   
                        var statusContran: Bool = false
                        
                        for item in self.companyList{
                            if(item.id == company.id){
                               statusContran = true
                            }
                        }
             
                        if(statusContran != true){
                            self.companyList.append(company)
                        }
                        
                        //print("Add bank \(bank.abbreviationTH!) \nURL: \(bank.logoUrl!)")
                    }
                    self.reloadData()
                    print("Call Company service success")
                    LoadingOverlay.shared.hideOverlayView()
                    self.versionGuideAddCard = VersionGuideAddCard.double(forKey: KEYGuideAddCard)
                    if(cerrentVersin != self.versionGuideAddCard){
                        self.viewController!.finishCallService()
                    }
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
    
    
    func CheckReachabilityStatus(statusDialogInternet: Bool? = false) {
        guard let status = Network.reachability?.status else { return }
        
        if (status == .unreachable) {
     
            if(statusDialogInternet != true){
                NoConnectionView.shared.Show(view: self.superview!,  action: reTryInternet)
            }
            isDisableInternet = true
        }else{
            isDisableInternet = false
        }
    }
    
    func reTryInternet(ClickBtn: Bool){
        if(ClickBtn){
            CheckReachabilityStatus(statusDialogInternet: true)
            if(!isDisableInternet){
                NoConnectionView.shared.Hide()
                CallCrediteBank()
            }
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
           cell.NameBank.text = crediteBankList[indexPath.row].abbreviationTH
            
        }else if(typeSelect == PrimoCardType.debitCard.rawValue){
            cell.cardImage.sd_setImage(with: URL(string: debiteBankList[indexPath.row].logoUrl))
            cell.NameBank.text = debiteBankList[indexPath.row].abbreviationTH

        }else{
            cell.cardImage.sd_setImage(with: URL(string: companyList[indexPath.row].logoUrl))
            cell.NameBank.text = companyList[indexPath.row].abbreviationTH

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
                self.viewController!.OnBankSelected(id: crediteBankList[indexPath.row].id , mCardType: crediteBankList[indexPath.row].cardType)
            }else if(typeSelect == PrimoCardType.debitCard.rawValue){
                self.viewController!.OnBankSelected(id: debiteBankList[indexPath.row].id, mCardType: debiteBankList[indexPath.row].cardType)
            }else{
                self.viewController!.OnBankSelected(id: companyList[indexPath.row].id, mCardType: companyList[indexPath.row].cardType)
            }
            

//            BankSelectIndex = indexPath
//            collectionView.reloadData()
//            
        }
    }

}


    
