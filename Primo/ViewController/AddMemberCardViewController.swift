
import UIKit
import DropDown
import Alamofire
import SwiftyJSON

struct Company {
    var id: Int!
    var name: String!
    init(json: JSON) {
        id = json["id"].intValue
        name = json["abbreviation"].stringValue
    }
}

class AddMemberCardViewController: UIViewController
{
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var companyButton: GrayButton!
    @IBOutlet weak var cardNameButton: GrayButton!
    @IBOutlet weak var addCardButton: GreenButton!
    @IBOutlet weak var doneButton: GreenButton!
    
    let companyDropDown = DropDown()
    let cardNameDropDown = DropDown()
    
    var companyList: [Company] = []
    var selectedCompany: Company?
    var cardsFromCompany: [PrimoCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupCompanyDropDown()
        
        CallCompanyService()
        
        cardImage.image = nil
        cardNameButton.isHidden = true
        addCardButton.isHidden = true
    }
    
    @IBAction func OnAddButtonClicked(_ sender: Any) {
        let selectedCard = cardsFromCompany[cardNameDropDown.indexForSelectedRow!]
        if (!CardDB.instance.getCards().contains(where: {$0.cardId == selectedCard.cardId})) {
            let result = CardDB.instance.addCard(cId: selectedCard.cardId,
                                                 cType: PrimoCardType.memberCard.rawValue,
                                                 cNameTH: selectedCard.nameTH,
                                                 cNameEN: selectedCard.nameEN,
                                                 cImgUrl: selectedCard.imgUrl)
            if (result != -1) {
                // success
                PrimoAlert().AddMemberSuccess(cardName: selectedCard.nameTH)
            } else {
                // failure
                PrimoAlert().Error()
            }
        } else {
            // already has this card
            PrimoAlert().AddMemberSuccess(cardName: selectedCard.nameTH)
        }
    }
}

extension AddMemberCardViewController
{
    //
    // MARK:- Company
    //
    func CallCompanyService() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        let params: Parameters = ["cardtype": PrimoCardType.memberCard.rawValue]
        Alamofire.request(Service.Company.url, parameters: params)
            .authenticate(user: Service_User, password: Service_Password)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (_, subJson):(String, JSON) in json["data"] {
                        self.companyList.append(Company(json: subJson))
                    }
                    self.SetCompanyDropDownDataSource()
                    print("Call Company service success | result \(self.companyList.count)")
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func SetupCompanyDropDown() {
        companyDropDown.anchorView = companyButton
        companyDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.companyButton.setTitle(item, for: .normal)
            if (index != 0) {
                self.selectedCompany = self.companyList[index - 1]
                self.cardNameButton.isHidden = false
                self.CallCardService()
                print("select index = \(index) | Name = \(self.selectedCompany!.name!) | ID = \(self.selectedCompany!.id!)")
            } else {
                self.selectedCompany = nil
                self.cardNameButton.isHidden = true
                print("select index = \(index)")
            }
            self.cardImage.image = nil
            self.addCardButton.isHidden = true
        }
        companyButton.addTarget(self, action: #selector(OnCompanyDropDownClicked),
                                for: .touchUpInside)
        SetCompanyDropDownDataSource()
    }
    
    func SetCompanyDropDownDataSource() {
        var datas = ["  กรุณาเลือกประเภทบัตรของคุณ"]
        for company in companyList {
            datas.append("  \(company.name!)")
        }
        companyDropDown.dataSource = datas
    }
    
    func OnCompanyDropDownClicked(_ sender: Any) {
        companyDropDown.show()
    }
    
    //
    // MARK:- Card
    //
    func CallCardService() {
        
        // Benz- clear list @2017-07-03
        cardsFromCompany.removeAll();
        // end Benz
        
        LoadingOverlay.shared.showOverlay(view: self.view)
        let params: Parameters = [
            "company": selectedCompany!.id!,
            "type": PrimoCardType.memberCard.rawValue,
            "inactive": "N"
        ]
        Alamofire.request(Service.Card.url, parameters: params)
            .authenticate(user: Service_User, password: Service_Password)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for (_, subJson):(String, JSON) in json["data"] {
                        self.cardsFromCompany.append(PrimoCard(json: subJson))
                    }
                    self.SetupCardNameDropDown()
                    print("Call Card service success | result \(self.cardsFromCompany.count)")
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func SetupCardNameDropDown() {
        cardNameButton.isHidden = false
        addCardButton.isHidden = false
        
        cardNameDropDown.anchorView = cardNameButton
        cardNameDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cardNameButton.setTitle(item, for: .normal)
            self.cardImage.sd_setImage(with: URL(string: self.cardsFromCompany[index].imgUrl),
                                       placeholderImage: nil,
                                       options: .retryFailed)
        }
        cardNameButton.addTarget(self, action: #selector(OnCardNameDropDownClicked),
                                 for: .touchUpInside)
        SetCardNameDropDownDataSource()
        
        // (pre)select
        cardNameDropDown.selectRow(at: 0)
        cardNameButton.setTitle(cardNameDropDown.dataSource[0], for: .normal)
        cardImage.sd_setImage(with: URL(string: cardsFromCompany[0].imgUrl),
                              placeholderImage: nil,
                              options: .retryFailed)
    }
    
    func SetCardNameDropDownDataSource() {
        var datas: [String] = []
        for card in cardsFromCompany {
            datas.append("  \(card.nameTH)")
        }
        cardNameDropDown.dataSource = datas
    }
    
    func OnCardNameDropDownClicked(_ sender: Any) {
        cardNameDropDown.show()
    }
    
}
