
import UIKit
import DatePickerDialog
import DropDown
import Alamofire
import SwiftyJSON

class DetailViewController: UIViewController
{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var placeCell: UIView!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var departmentButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var percentDiscountButton: UIButton!
    @IBOutlet weak var discountedPriceButton: UIButton!
    
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var priceLabelTop: NSLayoutConstraint!
    
    let dropDown = DropDown()
    var selectedPlace: Place!
    var departmentList: [String] = ["ทุกแผนก"]
    
    var currentPercentDiscount: Float = 0.0
    var dateSelected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up SideBar
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 150
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        SetPlaceCell()
        InitDateBtn(dateButton)
        HidePlaceDepartment()
        CallDepartmentService()
    }

    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if (segue.identifier == "ShowDeal") {
            let dealView = segue.destination as! DealViewController
//            dealView.date = self.dateButton.currentTitle!
            dealView.date = self.dateSelected
            let price = self.discountedPriceButton.currentTitle!.floatValueWithoutComma
            dealView.price = Int(price)
            dealView.store = selectedPlace.storeId
            dealView.branch = selectedPlace.branchId
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowDeal" {
            let price = self.discountedPriceButton.currentTitle!.floatValueWithoutComma
            if (price > 0) {
                // TODO: Show Dialog
                print("Price = \(price)")
                return true
            } else {
                PrimoAlert().PriceNotFound()
                return false
            }
        }
        // by default, transition
        return true
    }

    // MARK: Button Action
    @IBAction func OnDateButtonClicked(_ sender: Any) {
        DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { (date) -> Void in
//            let txt = "\(String(describing: date))"
//            let chars = txt.characters
//            if let paren = chars.index(of: "(") {
//                if let space = chars.index(of: " ") {
//                    let dateFormatterGet = DateFormatter()
//                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
//                    let dateFormatterPrint = DateFormatter()
//                    dateFormatterPrint.dateFormat = "dd-MM-yyyy"
//                    let date: Date? = dateFormatterGet.date(from: txt[chars.index(after: paren)..<space])
//                    self.dateButton.setTitle(dateFormatterPrint.string(from: date!), for: .normal)
//                }
//            }
            if let dt = date {
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
                dateFormatterGet.locale = Locale.init(identifier: "en_US")
                self.dateSelected = dateFormatterGet.string(from: dt)
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd-MM-yyyy"
                self.dateButton.setTitle(dateFormatterPrint.string(from: dt), for: .normal)
            }
        }
    }
    
    @IBAction func OnPriceButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "กรุณาใส่ราคา", message: "", preferredStyle: .alert)
            
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                self.priceButton.setTitle(field.text?.DecimalFormat(withComma: true), for: .normal)
                self.UpdateDiscountedPrice()
            } else {
                self.priceButton.setTitle("0.00", for: .normal)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.placeholder = "0.00"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func OnPercentDiscountButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "เปอร์เซ็นต์ส่วนลด (%)", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let field = alertController.textFields?[0] {
                self.currentPercentDiscount = field.text!.floatValueWithoutComma
                self.percentDiscountButton.setTitle("\(self.currentPercentDiscount)%", for: .normal)
            } else {
                self.currentPercentDiscount = self.percentDiscountButton.currentTitle!.floatValueWithoutComma
                self.percentDiscountButton.setTitle("0%", for: .normal)
            }
            self.UpdateDiscountedPrice()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        
        }
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.placeholder = "0.00"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func OnDepartmentButtonClicked(_ sender: Any) {
        dropDown.show()
    }
    
}

extension DetailViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
        
        if countdots > 0 && string == "." {
            return false
        }
        return true
    }
}

extension DetailViewController
{
    func InitDateBtn(_ btn: UIButton) {
        let locale = Locale(identifier: "th_TH")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = locale
        
        let date = Date()
        let dateString = formatter.string(from: date)
        
        btn.setTitle(dateString, for: .normal)
    }
    
    func CallDepartmentService() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        
        let url = Service.Department.url
        let user = Service_User
        let pass = Service_Password
        let params: Parameters = ["store": selectedPlace.storeId]
        Alamofire.request(url, parameters: params)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let departmentCount = json["page"]["total"].intValue
                    if(departmentCount > 0) {
                        self.ShowPlaceDepartment(json: json)
                    }
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    self.HidePlaceDepartment()
                    LoadingOverlay.shared.hideOverlayView()
                    PrimoAlert().Error()
                }
        }
    }
    
    func SetupDropdown() {
        // The view to which the drop down will appear on
        dropDown.anchorView = departmentButton // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = departmentList
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.departmentButton.setTitle(item, for: .normal)
        }
        
        // Will set a custom width instead of the anchor view width
        //dropDownLeft.width = 200
        
        let startAtIndex = 0
        dropDown.selectRow(at: startAtIndex)
        self.departmentButton.setTitle(departmentList[startAtIndex], for: .normal)
    }
    
    func SetPlaceCell() {
        if (selectedPlace == nil) { return }
        
        if let nameTH = placeCell.viewWithTag(101) as? UILabel {
            nameTH.text = selectedPlace.nameTH
        }
        if let nameEN = placeCell.viewWithTag(102) as? UILabel {
            nameEN.text = selectedPlace.nameEN
        }
        if let distance = placeCell.viewWithTag(103) as? UILabel {
            if (selectedPlace.distance >= 1000) {
                distance.text = selectedPlace.distance.ToStringWithKilo() + " km"
            } else {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                distance.text = (formatter.string(from:
                    NSNumber(value: selectedPlace.distance)) ?? "0") + " m"
            }
        }
        if let logoImg = placeCell.viewWithTag(104) as? UIImageView {
            logoImg.sd_setImage(with: URL(string: selectedPlace.imageUrl),
                                placeholderImage: UIImage(named: "star_preferred"))
            logoImg.sd_setShowActivityIndicatorView(true)
            logoImg.sd_setIndicatorStyle(.gray)
        }
    }
    
    func ShowPlaceDepartment(json: JSON) {
        departmentList.removeAll()
        departmentList.append("ทุกแผนก")
        for (_, subJson):(String, JSON) in json["data"] {
            departmentList.append(subJson["name"].stringValue)
        }
        SetupDropdown()
        
        departmentButton.isHidden = false
        departmentLabel.isHidden = false
        priceLabelTop.constant = 102
    }
    
    func HidePlaceDepartment() {
        departmentButton.isHidden = true
        departmentLabel.isHidden = true
        priceLabelTop.constant = 20
    }
    
    func UpdateDiscountedPrice() {
        let price:Float = self.priceButton.currentTitle!.floatValueWithoutComma
//        let percentDis:Float = self.percentDiscountButton.currentTitle!.floatValueWithoutComma
        let percentDis:Float = self.currentPercentDiscount
        let newPrice:Float = price * (1 - (percentDis / 100.0))
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let s2 = formatter.string(from: NSNumber(value: newPrice))
        print(s2 ?? "Can't format")
        
        self.discountedPriceButton.setTitle(s2, for: .normal)
    }
}
