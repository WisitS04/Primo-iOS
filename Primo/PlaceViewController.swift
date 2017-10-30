 import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Mixpanel

class PlaceViewController: UITableViewController{
    
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
    
    var FirstRunStep  = UserDefaults.standard
    var nLocationlat : Double = 0
    var nLocationLong : Double = 0
    var isClickSh: Bool = false
    var statusOpenDialogIN: Bool = false
    var stautsDisablePermission: Bool = false
    
    var mLocation: CLLocation? = nil
    var statusRun:Bool = false
    var KeySH:String = ""
    
    var isDisableInternet: Bool = false
    var projectToken: String = "1a4f60bd37af4cea7b199830b6bec468"
    
    var version: Double = 0.0
    var statusGuideNeayBy: Bool = false
    var statusDrawTable:Bool = false
    
    var newCard: [PrimoCard] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check Stroe DB
        _ = StoreDB.instance.CheckVertionStoreDB()
        
    
        

        self.navigationController?.navigationBar.isTranslucent = false
        statusDrawTable = false
        version = VersionNumber.double(forKey: KEYAppVersion)
        statusGuideNeayBy  = StatusGuideNeayBy.bool(forKey: KEYGuideNeayBy)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.setHidesBackButton(true, animated:true);
        
        if(cerrentVersin != version){
            CheckAppVersion()
        }else{
            
            if(!statusGuideNeayBy){
                GuideForNearby.shared.Show(view: self.view, navigationController: self.navigationController!, storyboard: self.storyboard! ,statusDrawTable: statusDrawTable)
                
            }

            let uuid = UIDevice.current.identifierForVendor!.uuidString
            
            Mixpanel.initialize(token: projectToken)
            Mixpanel.mainInstance().track(event: "Open Primo iOS")
            Mixpanel.mainInstance().identify(distinctId: uuid)
            Mixpanel.mainInstance().people.set(property: "UUID",
                                               to: uuid)
            
            
            // MARK: Set up Side bar
            if revealViewController() != nil {
                revealViewController().rightViewRevealWidth = 150
                menuButton.target = self.revealViewController()
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
                view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
            
            // MARK: Check Internet
            CheckReachabilityStatus()
            
            SetupSearchBar()
            // MARK: Pull and Refresh
            
            // MARK: Get Location
            locManager.stopUpdatingLocation()
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.requestWhenInUseAuthorization()
            
            self.refreshControl?.addTarget(self, action: #selector(HandleRefresh(_:)),for: UIControlEvents.valueChanged)
            
            GetLocation()
        }
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
                
                let uuid = UIDevice.current.identifierForVendor!.uuidString
                
                Mixpanel.initialize(token: projectToken)
                Mixpanel.mainInstance().track(event: "i_LocationSel_select",
                                              properties: ["StoreID" : place.storeId,
                                                           "BranchID" : place.branchId])
                Mixpanel.mainInstance().identify(distinctId: uuid)
                
                
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
        isClickSh = true
//        CallWS(searchkey: searchText)
        GetLocation(searchkey: searchText)
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
        searchController.hidesNavigationBarDuringPresentation = false
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
        
//        self.tableView.contentInset = UIEdgeInsets.zero
//        self.automaticallyAdjustsScrollViewInsets = false
        
        if !(searchBar.text?.isEmpty)! {
            searchText = searchBar.text!
            isClickSh = true
//            CallWS(searchkey: searchText)
            GetLocation(searchkey: searchText);
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = ""
        isClickSh = true

        if (self.isRefreshing) {
            self.refreshControl?.endRefreshing()
            self.isRefreshing = false
        }
        
        GetLocation();
//        CallWS()
    }
}


extension PlaceViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse
            || status == CLAuthorizationStatus.authorizedAlways) {
             stautsDisablePermission = false
//              GetLocation()
//            CallWS()
        } else if (status == CLAuthorizationStatus.denied) {
              stautsDisablePermission = true
//              GetLocation()
//            CallWS()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mLocation = manager.location!
        print("inside Update")
        if(mLocation != nil && statusRun == false){
            print("Update Location and call service")
            statusRun = true
            LoadingOverlay.shared.hideOverlayViewGPS()
//            CallWS(searchkey: KeySH)
            checkDataVertion(searchkey: KeySH)
        }
    }
}

extension PlaceViewController
{

    func CallWS(searchkey: String = "" , onCreate: Bool = false)
    {
            
            let mSearchkey:String = searchkey
            var distance : Float = 0
        
//             LoadingOverlay.shared.showOverlay(view: self.view)
       
            
            distance = getDistance()
            
            if (distance < 200 && isClickSh != true){
                
                let getResult = StoreDB.instance.getNewStores()
                
                if(getResult.isEmpty){
                    callNearbyService(searchkey: mSearchkey)
                }else{
                        self.nearByPlace.removeAll()
                        self.filteredPlace.removeAll()
                        
                        for item in getResult {
                            
                            let storeId = item.storeId
                            let branchId = item.branchId
                            let storeName = item.storeName
                            let storeNameEng = item.storeNameEng
                            let branchName = item.branchName
                            let branchNameEng = item.branchNameEng
                            let distance = item.distance
                            let imageUrl = item.imageUrl
                            let storeTypeId = item.storeTypeId
                            
                            let nameTH = (storeName != "") ? storeName + " " + branchName : branchName
                            let nameEN = (storeNameEng != "") ? storeNameEng + " " + branchNameEng : branchNameEng
                            
                            let place = Place(storeId: Int(storeId),
                                              branchId: Int(branchId),
                                              nameTH: nameTH,
                                              nameEN: nameEN,
                                              distance: Int(distance),
                                              imageUrl: imageUrl,
                                              storeTypeId: storeTypeId)
                            self.nearByPlace.append(place)
                            
                        }
                        
                        self.filteredPlace = self.nearByPlace
                        self.tableView.reloadData()
                        print("get DB and Add data fot Table success")
                        if ( self.isRefreshing) {
                            self.refreshControl?.endRefreshing()
                            self.isRefreshing = false
                        }
                        
                        LoadingOverlay.shared.hideOverlayView()
                        statusDrawTable = true
                }
                
            }else{
                CheckReachabilityStatus()
                if(!isDisableInternet){
                   callNearbyService(searchkey: mSearchkey)
                }
                self.tableView.reloadData()
            }
            isClickSh = false
            locManager.stopUpdatingLocation()
        
    }
    
    
    func callNearbyService(searchkey: String = ""){
        
        let url = Service.FindStoreDetailNearBy.url
        let user = "anonymous" // "abc@abc.com"
        let password = "spoton-primo" // "Cust-2014"
        
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
                    print("call Nerby service success")
                    self.CreatePlace(json)
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                    if (self.isRefreshing) {
                        self.refreshControl?.endRefreshing()
                        self.isRefreshing = false
                    }
                    PrimoAlert().Error()
                    
                }
        }
    }
    
    
    
    
    
    func checkDataVertion(searchkey: String = ""){
        
        LoadingOverlay.shared.showOverlay(view: self.view)

        let dataVersion: Double = DataVersionNumber.double(forKey: KEYDataVersion)
        
        let url = Service.DataVersion.url
        let user = Service_User
        let pass = Service_Password
        CheckReachabilityStatus()
        if(!isDisableInternet){
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
                                    self.checkVersionCard(searchkey:searchkey)
                                    DataVersionNumber.set(version,forKey: KEYDataVersion)
                                }else{
                                    self.CallWS(searchkey: searchkey )
                                }
                            }
                            
                            
                        }
                        print("Call DataVersion Service success")
                    case .failure(let error):
                        print(error)
                        LoadingOverlay.shared.hideOverlayView()
                        PrimoAlert().Error()
                    }
            }
        }
    }
    
    
    
    func checkVersionCard(searchkey: String = "" ){
        let Mycard: String = CheckMyCard()
        
        self.newCard.removeAll()
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
                PrimoAlert().Error()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                LoadingOverlay.shared.hideOverlayView()
                PrimoAlert().Error()
                
            }
            
            
            if(!data.isEmpty){
                DispatchQueue.main.async() { () -> Void in
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
                    print("Call CardbyList Service success : not nil")
                    self.CallWS(searchkey: searchkey )
                }
                
            }else{
                print("Call CardbyList Service success : nil")
                self.CallWS(searchkey: searchkey )
            }
            
        }
        task.resume()
    }
    
    
    
    func getDistance() -> Float{
        
        
        var location = btsSiam
        let mLastLatLocation:Double
        let mLongLocation:Double
        var distance:Float
        nLocationlat = 0
        nLocationLong = 0
        

         if let curLocation = mLocation {
                    location = Location(lat: Float(curLocation.coordinate.latitude),
                                        long: Float(curLocation.coordinate.longitude))
            
            nLocationlat = Double(location.lat)
            nLocationLong = Double(location.long)

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

        }else{
            LastLatLocation.set(location.lat, forKey: KEYLAT)
            LastLongLocation.set(location.long, forKey: KEYLONG)
        }
        
        
        return distance
    }


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
            print("CLLocationManager.authorizationStatus() = \(CLLocationManager.authorizationStatus().rawValue)")
            location = nil
//            PrimoAlert().GetLocationError()
        }
//        return location
        
        return location
        
        
    }
    
    
    func CheckReachabilityStatus(statusDialogInternet: Bool? = false) {
        guard let status = Network.reachability?.status else { return }
        
        if (status == .unreachable) {
            if (self.isRefreshing) {
                self.refreshControl?.endRefreshing()
                self.isRefreshing = false
            }
            
            self.refreshControl = nil
            self.tableView.separatorStyle = .none
            
//            if(!statusOpenDialogIN){
                LoadingOverlay.shared.hideOverlayView()
                LoadingOverlay.shared.hideOverlayViewGPS()
                
                self.nearByPlace.removeAll()
                self.filteredPlace.removeAll()
                self.tableView.reloadData()
                if(statusDialogInternet != true){
                  NoConnectionView.shared.Show(view: self.view,  action: self.reTryInternet)
                }
            
                statusOpenDialogIN = true
//            }
            isDisableInternet = true
        }else{
            isDisableInternet = false
        }
    }

    
    func GetLocation(searchkey: String = "" , onCreate: Bool = false){

        if(FirstRunStep.bool(forKey: KEYFIRSTRUN)){
                    if(!isDisableInternet){
                        NoConnectionView.shared.Hide()
                        self.tableView.separatorStyle = .singleLine
                        KeySH  = searchkey
                        mLocation = nil
                        statusRun = false
                        locManager.startUpdatingLocation()
            
                        print("GetLocation add call")
                        
                        if(self.refreshControl == nil){
                            self.refreshControl =  UIRefreshControl()
                            self.refreshControl?.addTarget(self, action: #selector(HandleRefresh(_:)), for: UIControlEvents.valueChanged)
                        }
                        if(mLocation != nil || stautsDisablePermission || mLocation != nil){
//                            CallWS(searchkey: searchkey , onCreate :onCreate)
                            checkDataVertion(searchkey: searchkey )
                        }else{
                            LoadingOverlay.shared.showDialogLoopGPS(view: self.view, action: self.isCancelLoopGPS)
                        }
    
                    }
        }else{
            self.refreshControl = nil
            UIApplication.shared.statusBarStyle = .lightContent
            Conidion.shared.Show(view: self.view, action: self.acceptCondition)
        }

    }
    
 
    //retry Internet
    func reTryInternet(ClickBtn: Bool){
        if(ClickBtn){
            CheckReachabilityStatus(statusDialogInternet: true)
            GetLocation()
        }
    }
    
    //LoopGPS
    func isCancelLoopGPS(isClick: Bool ) {
//        CallWS()
        checkDataVertion()
    }
    
    func acceptCondition(isClick: Bool ) {
        if(isClick){
          FirstRunStep.set(true, forKey: KEYFIRSTRUN)
          Conidion.shared.Hide()
          GetLocation()
        }
    }
    

    
    func CreatePlace(_ nearByJson: JSON) {
        
            self.nearByPlace.removeAll()
            self.filteredPlace.removeAll()
            
            _ = StoreDB.instance.deleteStore()
            
            for (_, subJson):(String, JSON) in nearByJson["data"] {
                
                
                let storeId = subJson["storeId"].intValue
                let branchId = subJson["branchId"].intValue
                
                let storeName = subJson["storeName"].stringValue
                let storeNameEng = subJson["storeNameEng"].stringValue
                
                let branchName = subJson["branchName"].stringValue
                let branchNameEng = subJson["branchNameEng"].stringValue
                
                let distance = subJson["distance"].intValue
                let imageUrl = subJson["logoUrl"].stringValue
                let storeTypeId = subJson["storeTypeId"].intValue
                
                let result = StoreDB.instance.addStore(cStoreId: Int64(storeId), cBranchId: Int64(branchId), cStoreName: storeName,
                                                       cStoreNameEng: storeNameEng, cBranchName: branchName, cBranchNameEng: branchNameEng,
                                                       cImageUrl: imageUrl, cDistance: Int64(distance), cStoreTypeId: storeTypeId)
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
                                      imageUrl: imageUrl,
                                      storeTypeId: storeTypeId)
                    self.nearByPlace.append(place)
                }
                
            }
            
            self.filteredPlace = self.nearByPlace
            self.tableView.reloadData()
            if (self.isRefreshing) {
                self.refreshControl?.endRefreshing()
                self.isRefreshing = false
            }

            statusDrawTable = true
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
    
    func CheckAppVersion(){
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Walkthrough") as! Walkthrough
            self.navigationController?.pushViewController(secondViewController, animated: true)

    }
    
}
