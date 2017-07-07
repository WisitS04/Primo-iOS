import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class PlaceViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let locManager = CLLocationManager()
    
    var nearByPlace = [Place]()
    var filteredPlace = [Place]()
    
    var isRefreshing: Bool = false
    var searchText: String = ""
    
    var LastLatLocation = UserDefaults.standard
    var LastLongLocation = UserDefaults.standard
    var nLocationlat : Double = 0
    var nLocationLong : Double = 0
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Set up Side bar
        if revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 150
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        // MARK: Check Internet
        CheckReachabilityStatus()
        
        // MARK: Call WebService
        CallWS()
        
        SetupSearchBar()
        
        // MARK: Get Location
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        
        // MARK: Pull and Refresh
        self.refreshControl?.addTarget(self, action: #selector(HandleRefresh(_:)), for: UIControlEvents.valueChanged)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if(segue.identifier == "ShowPlaceDetail")
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
//                self.searchController.searchBar.endEditing(true)
//                self.searchController.isActive = false
                
                let detailView = segue.destination as! DetailViewController
                
                var place: Place
                if searchController.isActive && searchController.searchBar.text != "" {
                    place = filteredPlace[indexPath.row]
                } else {
                    place = nearByPlace[indexPath.row]
                }
                detailView.selectedPlace = place
                
//                self.revealViewController().setFrontViewPosition(.left, animated: true)
            }
        }
    }
    
    // MARK: - Destructor
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPlace.count
        }
        return nearByPlace.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByCell", for: indexPath as IndexPath)
        
        let place: Place
        
        if searchController.isActive && searchController.searchBar.text != "" {
            place = filteredPlace[indexPath.row]
        } else {
            place = nearByPlace[indexPath.row]
        }
        
        if let nameTH = cell.viewWithTag(101) as? UILabel {
            nameTH.text = place.nameTH
        }
        
        if let nameEN = cell.viewWithTag(102) as? UILabel {
            nameEN.text = place.nameEN
        }
        
        if let distance = cell.viewWithTag(103) as? UILabel {
            if (place.distance >= 1000) {
                distance.text = place.distance.ToStringWithKilo() + " km"
            } else {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                distance.text = (formatter.string(from:
                    NSNumber(value: place.distance)) ?? "0") + " m"
            }
        }
        
        if let logoImg = cell.viewWithTag(104) as? UIImageView {
            logoImg.sd_setImage(with: URL(string: place.imageUrl),
                                placeholderImage: UIImage(named: "place_error"))
            logoImg.sd_setShowActivityIndicatorView(true)
            logoImg.sd_setIndicatorStyle(.whiteLarge)
            
        }
        return cell
    }
    
    func HandleRefresh(_ refreshControl: UIRefreshControl) {
        isRefreshing = true
        CallWS(searchkey: searchText)
    }
}

// MARK: Search Bar
extension PlaceViewController: UISearchResultsUpdating, UISearchBarDelegate
{
    func SetupSearchBar()
    {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ค้นหาร้านค้า, ร้านอาหาร, สถานที่"
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPlace = nearByPlace.filter { place in
            return (place.nameEN.lowercased().contains(searchText.lowercased()))
                || (place.nameTH.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)! {
            searchText = searchBar.text!
            CallWS(searchkey: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        CallWS()
    }
}

extension PlaceViewController
{
    func CallWS(searchkey: String = "")
    {
        LoadingOverlay.shared.showOverlay(view: self.view)
    
        let url = Service.FindStoreDetailNearBy.url
        let user = "anonymous" // "abc@abc.com"
        let password = "spoton-primo" // "Cust-2014"
        var distance : Float = 0
        let statusEnableLocationService:Bool = CheckStatusOpenGPS();
        
        if(statusEnableLocationService){
            distance = LoopGPS()
        }

//        if let curLocation = CheckLocation() {
//            location = Location(lat: Float(curLocation.coordinate.latitude),
//                                long: Float(curLocation.coordinate.longitude))
//        }
        
    

        if (distance < 200){
            
            let getResult = StoreDB.instance.getStores()
            for item in getResult {
                
                let storeId = item.storeId
                let branchId = item.branchId
                let storeName = item.storeName
                let storeNameEng = item.storeNameEng
                let branchName = item.branchName
                let branchNameEng = item.branchNameEng
                let distance = item.distance
                let imageUrl = item.imageUrl
                
                let nameTH = (storeName != "") ? storeName + " " + branchName : branchName
                let nameEN = (storeNameEng != "") ? storeNameEng + " " + branchNameEng : branchNameEng
                
                let place = Place(storeId: Int(storeId),
                                  branchId: Int(branchId),
                                  nameTH: nameTH,
                                  nameEN: nameEN,
                                  distance: Int(distance),
                                  imageUrl: imageUrl)
                nearByPlace.append(place)
                
            }
            
            filteredPlace = nearByPlace
            tableView.reloadData()
            if (isRefreshing) {
                refreshControl?.endRefreshing()
                isRefreshing = false
            }
            
            LoadingOverlay.shared.hideOverlayView()
            
        }else{
            
            let parameters: Parameters = ["lat": nLocationlat,
                                          "long": nLocationLong,
                                          "page": 1,
                                          "pageSize": 15,
                                          "search": searchkey]

            Alamofire.request(url, parameters: parameters)
                .authenticate(user: user, password: password)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("call service success")
                        self.CreatePlace(json)
                        LoadingOverlay.shared.hideOverlayView()
                    case .failure(let error):
                        print(error)
                        LoadingOverlay.shared.hideOverlayView()
                        PrimoAlert().Error()
                    }
        }
        
    
        
        }
    }
    
  
    
    func LoopGPS() -> Float{
        
        
        var location = btsSiam
        let mLastLatLocation:Double
        let mLongLocation:Double
        var distance:Float
        nLocationlat = 0
        nLocationLong = 0
        
         if let curLocation = CheckLocation() {
                    location = Location(lat: Float(curLocation.coordinate.latitude),
                                        long: Float(curLocation.coordinate.longitude))
            
            nLocationlat = Double(location.lat)
            nLocationLong = Double(location.long)
            
            LastLatLocation.set(location.lat, forKey: KEYLAT)
            LastLongLocation.set(location.long, forKey: KEYLONG)
            
         }
        
        mLastLatLocation  = LastLatLocation.double(forKey: KEYLAT)
        mLongLocation = LastLongLocation.double(forKey: KEYLONG)
        
        if(mLastLatLocation == 0 && mLongLocation == 0){
            let coordinate₀ = CLLocation(latitude: CLLocationDegrees(btsSiam.lat), longitude: CLLocationDegrees(btsSiam.long))
            let coordinate₁ = CLLocation(latitude: CLLocationDegrees(location.lat), longitude: CLLocationDegrees(location.long))
            distance = Float(coordinate₀.distance(from: coordinate₁))

        }else{
            
            let coordinate₀ = CLLocation(latitude: mLastLatLocation, longitude: mLongLocation)
            let coordinate₁ = CLLocation(latitude: CLLocationDegrees(location.lat), longitude: CLLocationDegrees(location.long))
            distance = Float(coordinate₀.distance(from: coordinate₁))
        }
        
        if(nLocationlat == 0 && nLocationLong == 0){
            if(mLastLatLocation != 0 && mLongLocation != 0){
                nLocationlat = mLastLatLocation
                nLocationLong = mLongLocation
            }else{
                nLocationlat = Double(btsSiam.lat)
                nLocationLong = Double(btsSiam.long)
            }
            
        }
        
        
        
        return distance
    }
    
    
    //Benz : add function check Enable Location Service : 06-07-2017 : Start
    func CheckStatusOpenGPS() -> Bool {
        var status:Bool = false
        if(CLLocationManager.locationServicesEnabled()){
            status = true
        }else{
            status = false
        }

        return status
    }
    //Benz : 06-07-2017 : End
    
    func CheckLocation() -> CLLocation?
    {
        var location: CLLocation? = nil
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse
            || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            print("lat = \(String(describing: locManager.location?.coordinate.latitude))\nlong = \(String(describing: locManager.location?.coordinate.longitude))")
            location = locManager.location
        }
        else if (CLLocationManager.authorizationStatus() == .denied
            || CLLocationManager.authorizationStatus() == .notDetermined
            || CLLocationManager.authorizationStatus() == .restricted) {
            print("CLLocationManager.authorizationStatus() = \(CLLocationManager.authorizationStatus())")
            location = nil
            PrimoAlert().GetLocationError()
        }
        return location
    }
    
    func CheckReachabilityStatus() {
        guard let status = Network.reachability?.status else { return }
        if (status == .unreachable) {
//            NoConnectionView.shared.Show(view: self.view)
            PrimoAlert().NoInternet()
        }
    }
    
    
    
    

    func CreatePlace(_ nearByJson: JSON) {
        nearByPlace.removeAll()
        filteredPlace.removeAll()

            for (_, subJson):(String, JSON) in nearByJson["data"] {
      
            
                let storeId = subJson["storeId"].intValue
                let branchId = subJson["branchId"].intValue
                
                let storeName = subJson["storeName"].stringValue
                let storeNameEng = subJson["storeNameEng"].stringValue
                
                let branchName = subJson["branchName"].stringValue
                let branchNameEng = subJson["branchNameEng"].stringValue
                
                let distance = subJson["distance"].intValue
                let imageUrl = subJson["logoUrl"].stringValue
                
    
                _ = StoreDB.instance.deleteStore()
                let result = StoreDB.instance.addStore(cStoreId: Int64(storeId), cBranchId: Int64(branchId), cStoreName: storeName,
                                                       cStoreNameEng: storeNameEng, cBranchName: branchName, cBranchNameEng: branchNameEng,
                                                       cImageUrl: imageUrl, cDistance: Int64(distance))
                if(result == -1){
                    PrimoAlert().Error()
                }else{
                    
                    let nameTH = (storeName != "") ? storeName + " " + branchName : branchName
                    let nameEN = (storeNameEng != "") ? storeNameEng + " " + branchNameEng : branchNameEng
                    
                    let place = Place(storeId: storeId,
                                      branchId: branchId,
                                      nameTH: nameTH,
                                      nameEN: nameEN,
                                      distance: distance,
                                      imageUrl: imageUrl)
                    nearByPlace.append(place)
                }
   
            }
            
            filteredPlace = nearByPlace
            tableView.reloadData()
            if (isRefreshing) {
                refreshControl?.endRefreshing()
                isRefreshing = false
            }

    }
}
