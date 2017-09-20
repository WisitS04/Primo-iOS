
import UIKit
import DropDown

class DealViewController: UIViewController
{
    var dealTableView: DealTableVC!
    @IBOutlet weak var usePointButton: DealFilterButton!
    @IBOutlet weak var useInstallmentButton: DealFilterButton!
    
    @IBOutlet weak var usePayFullButton: DealFilterButton!
    
    @IBOutlet weak var useNotUsePoint: DealFilterButton!
    
    
//    @IBOutlet weak var myCardButton: UIButton!
    
    @IBOutlet weak var controllPanelHeight: NSLayoutConstraint!
//    @IBOutlet weak var pointPanel: UIView!
//    @IBOutlet weak var pointField: UITextField!
    
    var date: String = ""
    var price: Int = 0
    var store: Int = 0
    var branch: Int = 0
    var departmentId: Int = 0
    let dropDown = DropDown()
    
    var myCardList: [PrimoCard] = []
    var myCardListBuffer: [PrimoCard] = []
    var selectedCard: PrimoCard?
    var selectedDeal: Deal?
    
    var btn_point: Bool = false
    var btn_not_point: Bool = false
    var btn_full_peyment:Bool = false
    var btn_installment:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        myCardList = CardDB.instance.getCards()
        myCardListBuffer = myCardList

        SetupKeyboard()
//Benz Comment
//        SetupDropDown()
//        HidePointPanel()
        
        
      
//        pointField.delegate = self
//        pointField.keyboardType = .numberPad
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        if (segue.identifier == "DealTableEmbed") {
            if let dealTable = segue.destination as? DealTableVC {
                  //Benz Comment
//                self.SetupUsePointButton()
                
                SetupUsePointButton()
                
                dealTable.controllrtDeals = self
                dealTable.date = self.date
                dealTable.price = self.price
                dealTable.store = self.store
                dealTable.branch = self.branch
                dealTable.departmentId = self.departmentId
                
                dealTable.UpdateData(usePoint: btn_point,
                                         installment: btn_installment,
                                         Peyment: btn_full_peyment,
                                         UnPoint: btn_not_point,
                                         callWS: true,
                                         mCard: myCardListBuffer)
                
                self.dealTableView = dealTable
            }
        } else if (segue.identifier == "ShowDealDetail") {
            if let dealDetailView = segue.destination as? DealDetailViewController {
                if (selectedDeal != nil) {
                    dealDetailView.SetDeal(selectedDeal!)
                }
            }
        }
    }
    
    @IBAction func OnUsePointButtonClicked(_ sender: Any) {
        let btn = sender as! DealFilterButton
        
        btn_point = true
        btn_not_point = false
        
        btn.isUsing = true
        btn.OnUsing()
        if(btn.isUsing){
            useNotUsePoint.OnUnuse()
        }
        
//        btn.isUsing = !btn.isUsing
//        if (btn.isUsing) {
//            btn.OnUsing()
//        } else {
//            btn.OnUnuse()
//        }
        dealTableView.UpdateData(usePoint: btn_point,
                                 installment: btn_installment,
                                 Peyment: btn_full_peyment,
                                 UnPoint: btn_not_point,
                                 callWS: false,
                                 mCard: myCardListBuffer)
    }
    
    @IBAction func OnUseInstallmentButtonClicked(_ sender: Any) {
        let btn = sender as! DealFilterButton
        
        btn_installment = true
        btn_full_peyment = false
        
        btn.isUsing = true
        btn.OnUsing()
        if(btn.isUsing){
           usePayFullButton.OnUnuse()
        }
//        btn.isUsing = !btn.isUsing
//        if (btn.isUsing) {
//            btn.OnUsing()
//        } else {
//            btn.OnUnuse()
//        }
        dealTableView.UpdateData(usePoint: btn_point,
                                 installment: btn_installment,
                                 Peyment: btn_full_peyment,
                                 UnPoint: btn_not_point,
                                 callWS: false,
                                 mCard: myCardListBuffer)
    }
    
    
    @IBAction func OnUsePatFullButtonClicked(_ sender: Any) {
        let btn = sender as! DealFilterButton
        
        btn_full_peyment = true
        btn_installment = false
        
         btn.isUsing = true
         btn.OnUsing()
        if(btn.isUsing){
            useInstallmentButton.OnUnuse()
        }
//        btn.isUsing = !btn.isUsing
//        if (btn.isUsing) {
//            btn.OnUsing()
//        } else {
//            btn.OnUnuse()
//        }
        dealTableView.UpdateData(usePoint: btn_point,
                                 installment: btn_installment,
                                 Peyment: btn_full_peyment,
                                 UnPoint: btn_not_point,
                                 callWS: false,
                                 mCard: myCardListBuffer)

    }
    
    @IBAction func OnUseNotPointRedemButtonClicked(_ sender: Any) {
        let btn = sender as! DealFilterButton
        
        btn_not_point = true
        btn_point = false
        
        btn.isUsing = true
        btn.OnUsing()
        if(btn.isUsing){
            usePointButton.OnUnuse()
        }
        
//        btn.isUsing = !btn.isUsing
//        if (btn.isUsing) {
//            btn.OnUsing()
//        } else {
//            btn.OnUnuse()
//        }
        dealTableView.UpdateData(usePoint: btn_point,
                                 installment: btn_installment,
                                 Peyment: btn_full_peyment,
                                 UnPoint: btn_not_point,
                                 callWS: false,
                                 mCard: myCardListBuffer)

    }

    
//    @IBAction func OnIncreasePointClicked(_ sender: Any) {
//        var curPoint = Int(pointField.text!) ?? 0
//        curPoint += 100
//        pointField.text = String(curPoint)
//    }
//    
//    @IBAction func OnDecreasePointClicked(_ sender: Any) {
//        var curPoint = Int(pointField.text!) ?? 0
//        curPoint -= 100
//        if (curPoint >= 0) {
//            pointField.text = String(curPoint)
//        } else {
//            pointField.text = "0"
//        }
//    }

//Benz comment
//    @IBAction func OnRefreshButtonClicked(_ sender: Any) {
//        selectedCard?.point = Int(pointField.text!) ?? 0
//        if (CardDB.instance.updateCard(cId: (selectedCard?.cardId)!, newCard: selectedCard!)) {
//            dealTableView.UpdateData(usePoint: self.usePointButton.isUsing,
//                                     installment: self.useInstallmentButton.isUsing)
//        }
//    }
}

extension DealViewController
{
    
    func OnReFreshCallService(card :PrimoCard){
        for buffer in myCardListBuffer{
            if(buffer.cardId == card.cardId){
                buffer.pointToUse = card.pointToUse
            }
        }
        dealTableView.UpdateData(usePoint: btn_point,
                                 installment: btn_installment,
                                 Peyment: btn_full_peyment,
                                 UnPoint: btn_not_point,
                                 callWS: true,
                                 editePoint: true,
                                 mCard: myCardListBuffer)
    }
    
    //Benz Comment
    
//    func SetupDropDown(isUpdate: Bool = false) {
//        // The view to which the drop down will appear on
//        dropDown.anchorView = myCardButton // UIView or UIBarButtonItem
//        
//        // The list of items to display. Can be changed dynamically
//        var cardList: [String] = ["  กรุณาเลือกบัตรที่จะใช้คะแนนสะสม"]
//        for card in myCardList {
//            cardList.append("  \(card.nameTH)")
//        }
//        dropDown.dataSource = cardList
//        
//        // Will set a custom width instead of the anchor view width
//        //dropDownLeft.width = 200
//        
//        if !isUpdate {
//            // Action triggered on selection
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                self.myCardButton.setTitle(item, for: .normal)
//                if (index == 0) {
//                    self.HidePointPanel()
//                } else {
//                    self.selectedCard = self.myCardList[index - 1]
//                    self.ShowPointPanel()
//                }
//            }
//            
//            myCardButton.addTarget(self, action: #selector(OnMyCardButtonClicked),
//                                   for: .touchUpInside)
//        }
//    }
    
//    func OnMyCardButtonClicked(_ sender: Any) {
//        dropDown.show()
//    }
    
//    func ShowPointPanel() {
//        pointPanel.isHidden = false
//        let curPoint = selectedCard?.point ?? 0
//        if (curPoint > 0) {
//            pointField.text = String(curPoint)
//        } else {
//            pointField.text = ""
//        }
//        controllPanelHeight.constant = 160
//    }
    
//    func HidePointPanel() {
//        pointPanel.isHidden = true
//        controllPanelHeight.constant = 110
//    }
    
    func SetupUsePointButton() {
        usePayFullButton.isUsing = true
        usePayFullButton.OnUsing()
        btn_full_peyment = true
        btn_installment = false
        
        usePointButton.isUsing = true
        usePointButton.OnUsing()
        btn_point = true
        btn_not_point = false

    }
    
    func UpdateCardData(cardList: [PrimoCard]) {
        myCardList = cardList
        
        //Benz comment
//        SetupDropDown()
    }
    
    func OnDealSelected(_ deal: Deal) {
        selectedDeal = deal
        performSegue(withIdentifier: "ShowDealDetail", sender: nil)
    }
}

extension DealViewController: UITextFieldDelegate
{
    func SetupKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.OnDoneButtonClicked))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
       // Benz comment
        
//        pointField.inputAccessoryView = toolbar
    }
    
    func OnDoneButtonClicked() {
        self.view.endEditing(true)
    }
}
