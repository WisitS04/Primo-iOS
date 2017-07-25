
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class BankCollectionView: UICollectionView
{
    var viewController: PageMenuViewController?
    
    var bankList: [Bank] = []
    
    func SetUp(viewController: PageMenuViewController) {
        self.viewController = viewController
        self.delegate = self
        self.dataSource = self
        BankSelectIndex =  IndexPath(item: -1, section: -1)
    }
}

//
// MARK: Methor
//
extension BankCollectionView
{
    func LoadBankList(cardType: Int) {
        LoadingOverlay.shared.showOverlay(view: self.superview!)
        
        let url = Service.Banks.url
        let user = Service_User
        let pass = Service_Password
        let param: Parameters = [ "cardType": cardType ]
        
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
}

//
// MARK: Collection Delegate & DataSource
//
extension BankCollectionView: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bankList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.cardImage.sd_setImage(with: URL(string: bankList[indexPath.row].logoUrl))
        
        
        
        if(BankSelectIndex.item != -1 && BankSelectIndex.section != -1){
            if(BankSelectIndex != indexPath){
                cell.statusImage.image = UIImage(named: "buttongrey")
            }else{
                cell.statusImage.image = UIImage(named: "button_check")
            }
        }else{
            cell.statusImage.image = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (viewController != nil) {
            self.viewController!.OnBankSelected(id: bankList[indexPath.row].id)
            
            BankSelectIndex = indexPath
            collectionView.reloadData()

        }
    }
   
}
