
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
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var priceLabelTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var lablePrice: UILabel!
    @IBOutlet weak var percentDiscountButton: UIButton!
    @IBOutlet weak var discountedPriceButton: UIButton!
    @IBOutlet weak var lablePercen: UILabel!
    @IBOutlet weak var lableDiscount: UILabel!

    
    @IBOutlet var line_top_description: NSLayoutConstraint!
    @IBOutlet var lable_description: UILabel!
    
    let dropDown = DropDown()
    var selectedPlace: Place!
    var departmentList: [String] = ["ทุกแผนก"]
    var RestaurantList: [String] = ["จำนวนคน","ยอดใช้จ่ายโดยประมาณ"]
//    var departmentListId = [Int]()
    
    var DepAndRestaurant = [RestaurantPrice]()
    
    var currentPercentDiscount: Float = 0.0
    var dateSelected: String = ""
    var depSelect: Int = 0
    var selectTypeRestaurant: Int = 0
    var statusGuideDetail: Bool = false
    var statusGuideDetailNotDep: Bool = false
    var TypeRestaurantPrice: Int? = 0
    
    var priceDialog :Float? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lable_description.isHidden = true
      
         statusGuideDetail  = StatusGuideDetail.bool(forKey: KEYGuideDetail)
         statusGuideDetailNotDep = StatusGuideDetailNotDep.bool(forKey: KEYGuideNotDepDetail)
        
//         GuideForDetail.shared.Show(view: self.view, navigationController: self.navigationController!)
        
        // Set up SideBar
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 150
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        SetPlaceCell()
        InitDateBtn(dateButton)
        CheckpRestaurant()
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
            dealView.departmentId = depSelect
            dealView.typeStoreID = selectedPlace.storeTypeId!
            dealView.RestaurantStatus = selectTypeRestaurant
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
                PrimoAlert().PriceNotFound(index :selectTypeRestaurant)
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
        
        var titleForDialog: String?
        TypeRestaurantPrice = 0
        if(selectedPlace.storeTypeId! == 11){
            
             if(selectTypeRestaurant == 1){
                titleForDialog = "จำนวนคน"
            }else if(selectTypeRestaurant == 2){
                titleForDialog = "ยอดใช้จ่ายโดยประมาณ"
             }
            
            if(selectTypeRestaurant > 0){
                let alertController = UIAlertController(title: titleForDialog, message: "", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "ตกลง", style: .default) { (_) in
                    if let field = alertController.textFields?[0] {
                        if((field.text?.length)! > 0){
                            let value = field.text
                            self.TypeRestaurantPrice = Int(value!)
                        }else{
                            self.TypeRestaurantPrice = 0
                        }
                        
                        do {
                            if(self.selectTypeRestaurant == 1){
                                let total = String(describing: (field.text?.DecimalFormat(withComma: true))! + " คน")
                                self.priceButton.setTitle(total , for: .normal)
                                
                            }else {
                                let total = String(describing: (field.text?.DecimalFormat(withComma: true))! + " บาท")
                                self.priceButton.setTitle(total , for: .normal)
                            }
                        } catch {
                            if(self.selectTypeRestaurant == 1){
                                self.priceButton.setTitle("0 คน", for: .normal)
                                
                            }else {
                                self.priceButton.setTitle("0.00 บาท", for: .normal)
                            }
                        }
                        
                        self.priceDialog = (field.text?.floatValueWithoutComma)!
                        
                        self.UpdateDiscountedPrice()
                    } else {
                        if(self.selectTypeRestaurant == 1){
                            self.priceButton.setTitle("0 คน", for: .normal)
                            
                        }else {
                            self.priceButton.setTitle("0.00 บาท", for: .normal)
                        }
                        
                    }
                }
                
                let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel) { (_) in
                    
                }
                
                alertController.addTextField { (textField) in
                    textField.delegate = self
                    textField.keyboardType = .decimalPad
                    if(self.selectTypeRestaurant == 1){
                        textField.placeholder = "0"
                    }else{
                       textField.placeholder = "0.00"
                    }
                    
                }
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }else{
            let alertController = UIAlertController(title: "กรุณาใส่ราคา", message: "", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "ตกลง", style: .default) { (_) in
                if let field = alertController.textFields?[0] {
                    self.priceButton.setTitle(field.text?.DecimalFormat(withComma: true), for: .normal)
                    self.priceDialog = (field.text?.floatValueWithoutComma)!
                    self.UpdateDiscountedPrice()
                } else {
                    self.priceButton.setTitle("0.00", for: .normal)
                }
            }
            
            let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel) { (_) in
                
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
    }
    
    @IBAction func OnPercentDiscountButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "เปอร์เซ็นต์ส่วนลด (%)", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "ตกลง", style: .default) { _ in
            if let field = alertController.textFields?[0] {
                self.currentPercentDiscount = field.text!.floatValueWithoutComma
                self.percentDiscountButton.setTitle("\(self.currentPercentDiscount)%", for: .normal)
            } else {
                self.currentPercentDiscount = self.percentDiscountButton.currentTitle!.floatValueWithoutComma
                self.percentDiscountButton.setTitle("0%", for: .normal)
            }
            self.UpdateDiscountedPrice()
        }
        
        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel) { (_) in
        
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
        let params: Parameters = ["store": selectedPlace.storeId,
                                  "branch": selectedPlace.branchId]
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
                    
                    if(departmentCount > 0){
                        if(!self.statusGuideDetail){
                            GuideForDetail.shared.Show(view: self.view, navigationController: self.navigationController! , MydepartmentCount :departmentCount)
                        }
                    }else{
                        if(!self.statusGuideDetailNotDep){
                            GuideForDetail.shared.Show(view: self.view, navigationController: self.navigationController! , MydepartmentCount :departmentCount)
                        }
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
    
    
    func CallRestaurantPriceService(){
        LoadingOverlay.shared.showOverlay(view: self.view)
        let url = Service.RestaurantPrice.url
        let user = Service_User
        let pass = Service_Password
        let params: Parameters = ["store": selectedPlace.storeId,
                                  "branch": selectedPlace.branchId]
        
        
        Alamofire.request(url, parameters: params)
            .authenticate(user: user, password: pass)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.ShowPlaceDepartment(json: json)
                    
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
            if(index > 0){
              self.depSelect = Int(self.DepAndRestaurant[index-1].id!)
            }else{
              self.depSelect = 0
            }
        }
        
        // Will set a custom width instead of the anchor view width
        //dropDownLeft.width = 200
        
        let startAtIndex = 0
        dropDown.selectRow(at: startAtIndex)
        self.departmentButton.setTitle(departmentList[startAtIndex], for: .normal)
    }
    
    
    func SetupDropdownRestaurant() {
        dropDown.anchorView = departmentButton
        dropDown.dataSource = RestaurantList
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.departmentButton.setTitle(item, for: .normal)
            self.selectTypeRestaurant = index + 1
            
            if(self.selectTypeRestaurant == 0){
                self.priceButton.setTitleColor(UIColor.gray, for: .normal)
            }else{
                self.priceButton.setTitleColor(UIColor.black, for: .normal)
            }
            
            if(self.selectTypeRestaurant == 2){
               self.lable_description.isHidden = false
               self.lable_description.text = "* ราคานี้ไม่รวมเครื่องดื่มทุกประเภท"
               self.priceButton.setTitle("0.00 บาท", for: .normal)
            }else{
                self.priceButton.setTitle("0 คน", for: .normal)
                self.lable_description.isHidden = true
            }
            
        }
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
        DepAndRestaurant.removeAll()
        departmentList.removeAll()
        
        departmentList.append("ทุกแผนก")
        for (_, subJson):(String, JSON) in json["data"] {
            departmentList.append(subJson["name"].stringValue)

            //dep
            let id = subJson["id"].int64Value
            let name = subJson["name"].stringValue
            
            
            //restaurant
            let branchId = subJson["branchId"].int64Value
            let branchName = subJson["branchName"].stringValue
            let branchNameEng = subJson["branchNameEng"].stringValue
            let brandId = subJson["brandId"].int64Value
            let brandName = subJson["brandName"].stringValue
            let brandNameEng = subJson["brandNameEng"].stringValue
            let lowerPrice = subJson["lowerPrice"].intValue
            let middlePrice = subJson["middlePrice"].intValue
            let storeDetailId = subJson["storeDetailId"].int64Value
            let storeId = subJson["storeId"].int64Value
            let storeName = subJson["storeName"].stringValue
            let storeNameEng = subJson["storeNameEng"].stringValue
            let storeTypeId = subJson["storeTypeId"].int64Value
            let storeTypeName = subJson["storeTypeName"].stringValue
            let storeTypeNameEng = subJson["storeTypeNameEng"].stringValue
            let upperPrice = subJson["upperPrice"].intValue
            
            let mDepAndRestaurant = RestaurantPrice(id: id,
                                                    name: name,
                                                    branchId: branchId,
                                                    branchName: branchName,
                                                    branchNameEng: branchNameEng,
                                                    brandId: brandId,
                                                    brandName: brandName,
                                                    brandNameEng: brandNameEng,
                                                    lowerPrice: lowerPrice,
                                                    middlePrice: middlePrice,
                                                    storeDetailId: storeDetailId,
                                                    storeId: storeId,
                                                    storeName: storeName,
                                                    storeNameEng: storeNameEng,
                                                    storeTypeId: storeTypeId,
                                                    storeTypeName: storeTypeName,
                                                    storeTypeNameEng: storeTypeNameEng,
                                                    upperPrice: upperPrice)
            
            
            DepAndRestaurant.append(mDepAndRestaurant)
            
        }
        if(selectedPlace.storeTypeId! == 11){
           SetupDropdownRestaurant()
        }else{
            SetupDropdown()
        }
        
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
        let price:Float = priceDialog!
//        let percentDis:Float = self.percentDiscountButton.currentTitle!.floatValueWithoutComma
        let percentDis:Float = self.currentPercentDiscount
        let newPrice:Float = price * (1 - (percentDis / 100.0))
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var s2 = formatter.string(from: NSNumber(value: newPrice))
    
        
        if(selectTypeRestaurant == 1 && selectedPlace.storeTypeId! == 11){
            if(!DepAndRestaurant.isEmpty){
                let data = TypeRestaurantPrice! * DepAndRestaurant[0].middlePrice!
                s2 = formatter.string(from: NSNumber(value:data))
            }else{
                s2 = formatter.string(from: NSNumber(value:0))
            }
        }
        print(s2 ?? "Can't format")
        self.discountedPriceButton.setTitle(s2, for: .normal)
    }
    
    
    func CheckpRestaurant(){
        if(selectedPlace.storeTypeId! == 11){
            
           CallRestaurantPriceService()
           percentDiscountButton.isHidden = true
           discountedPriceButton.isHidden = true
           lablePercen.isHidden = true
           lableDiscount.isHidden = true
           lablePrice.text = ""
           departmentLabel.text = "จำนวนคน / ยอดใช้จ่ายโดยประมาณ"
           departmentButton.setTitle("โปรดเลือกวิธีคำนวณ", for: .normal)
           line_top_description.constant = 20
           priceButton.setTitleColor(UIColor.gray, for: .normal)
        }else{
            HidePlaceDepartment()
            CallDepartmentService()
            percentDiscountButton.isHidden = false
            discountedPriceButton.isHidden = false
            lablePercen.isHidden = false
            lableDiscount.isHidden = false
        }
    }
}
