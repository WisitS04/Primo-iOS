import UIKit
import Alamofire
import SwiftyJSON
import DropDown

class PlaceDetail_Test: UIViewController
{
    @IBOutlet weak var placeCell: UIView!
    @IBOutlet weak var depBtn: UIButton!
    
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var departmentButton: GrayButton!
    @IBOutlet weak var priceLabelConstraint: NSLayoutConstraint!
    
    let dropDown = DropDown()
    var selectedPlace: Place!
    var departmentList: [String] = ["ทุกแผนก"]
    
    var dialog: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetPlaceCell()
        HidePlaceDepartment()
        CallDepartmentService()
    }

}

extension PlaceDetail_Test
{
    func SetPlaceCell()
    {
        if let nameTH = placeCell.viewWithTag(101) as? UILabel
        {
            nameTH.text = selectedPlace.nameTH
        }
        if let nameEN = placeCell.viewWithTag(102) as? UILabel
        {
            nameEN.text = selectedPlace.nameEN
        }
        if let distance = placeCell.viewWithTag(103) as? UILabel
        {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let distanceText = (formatter.string(from: selectedPlace.distance as NSNumber) ?? "0") + " m"
            distance.text = distanceText
        }
        if let logoImg = placeCell.viewWithTag(104) as? UIImageView
        {
            logoImg.sd_setImage(with: URL(string: selectedPlace.imageUrl),
                                placeholderImage: UIImage(named: "star_preferred"))
            logoImg.sd_setShowActivityIndicatorView(true)
            logoImg.sd_setIndicatorStyle(.gray)
        }
    }
    
    func CallDepartmentService()
    {
        //dialog = DisplaySignUpPendingAlert()
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
                    if(departmentCount > 0)
                    {
                        self.ShowPlaceDepartment(json: json)
                    }
                    //self.CloseDialog()
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    self.HidePlaceDepartment()
                    //self.CloseDialog()
                    LoadingOverlay.shared.hideOverlayView()
                }
        }
    }
    
    func ShowPlaceDepartment(json: JSON)
    {
        departmentList.removeAll()
        departmentList.append("ทุกแผนก")
        for (_, subJson):(String, JSON) in json["data"]
        {
            departmentList.append(subJson["name"].stringValue)
        }
        SetupDropdown()
        
        departmentButton.isHidden = false
        departmentLabel.isHidden = false
        priceLabelConstraint.constant = 102
    }
    
    func HidePlaceDepartment()
    {
        departmentButton.isHidden = true
        departmentLabel.isHidden = true
        priceLabelConstraint.constant = 20
    }
    
    func SetupDropdown()
    {
        // The view to which the drop down will appear on
        dropDown.anchorView = depBtn // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = departmentList
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.depBtn.setTitle(item, for: .normal)
        }
        
        // Will set a custom width instead of the anchor view width
        //dropDownLeft.width = 200
        
        depBtn.addTarget(self, action: #selector(OnDepartmentButtonClicked), for: .touchUpInside)

    }
    
    func OnDepartmentButtonClicked(sender: UIButton!)
    {
        dropDown.show()
    }
    
    func DisplaySignUpPendingAlert() -> UIAlertController {
        //create an alert controller
        let pending = UIAlertController(title: "กำลังค้นหา", message: nil, preferredStyle: .alert)
        
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        indicator.tag = 888
        self.present(pending, animated: true, completion: nil)
        
        return pending
    }
    
    func CloseDialog()
    {
        if let indicator = dialog.view.viewWithTag(888) as? UIActivityIndicatorView {
            indicator.stopAnimating()
        }
        self.dismiss(animated: true, completion: nil)
    }
}
