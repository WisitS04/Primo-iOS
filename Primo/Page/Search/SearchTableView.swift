//
//  SearchTableView.swift
//  Primo
//
//  Created by spoton on 28/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import UIKit

class SearchTableView: UITableView {
    
    var viewController: SearchViewController!
    var SearchDataList = [Place]()
    var filteredSearchDataList = [Place]()
    
    var mySearchBar =  UISearchBar()
    var searchText: String = ""
    
    func SetUp(viewController: SearchViewController) {
        self.viewController = viewController
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50.0
        setSearchBar()
        
    }
    
}


extension SearchTableView : UISearchResultsUpdating, UISearchBarDelegate{

    
    func setSearchBar()  {
        
        mySearchBar.delegate = self
        mySearchBar.frame = CGRect(x: 0, y: 0, width:  self.contentSize.width , height: 50)
        //        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 100)
        mySearchBar.layer.masksToBounds = false
        mySearchBar.showsCancelButton = false
        mySearchBar.showsBookmarkButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.default
        mySearchBar.placeholder = "สถานที่ล่าสุด"
        mySearchBar.showsSearchResultsButton = false
        self.tableHeaderView = mySearchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(!mySearchBar.showsCancelButton) {
            mySearchBar.showsCancelButton = true
        }
        filterContentForSearchText(searchText:searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSearchDataList = SearchDataList.filter { place in
            return (place.nameEN.lowercased().contains(searchText.lowercased()))
                || (place.nameTH.lowercased().contains(searchText.lowercased()))
        }
        self.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !(searchBar.text?.isEmpty)! {
            searchText = searchBar.text!
            self.viewController.view.endEditing(true)

            //do Something
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mySearchBar.showsCancelButton = false
         self.viewController.view.endEditing(true)
        searchText = ""
 
        //  do Something
    }
    
}


extension SearchTableView {
    
    func getDataDB(){
        
        let getResult = SearchDB.instance.getStores()
        
        if(getResult.isEmpty){
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
                self.SearchDataList.append(place)
                self.filteredSearchDataList = self.SearchDataList
                self.reloadData()
            }
        }
    }
    
    
    func CallServiceSearch(searchkey: String = ""){
        
//        let url = Service.FindStoreDetailNearBy.url
//        let user = "anonymous" // "abc@abc.com"
//        let password = "spoton-primo" // "Cust-2014"
//
//        let parameters: Parameters = ["lat": nLocationlat,
//                                      "long": nLocationLong,
//                                      "page": 1,
//                                      "pageSize": 25,
//                                      "search": searchkey]
//
//        Alamofire.request(url, parameters: parameters)
//            .authenticate(user: user, password: password)
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    print("call Nerby service success")
//                    self.CreatePlace(json)
//                    LoadingOverlay.shared.hideOverlayView()
//                case .failure(let error):
//                    print(error)
//                    LoadingOverlay.shared.hideOverlayView()
//                    if (self.isRefreshing) {
//                        self.refreshControl?.endRefreshing()
//                        self.isRefreshing = false
//                    }
//                    PrimoAlert().Error()
//
//                }
//        }

    }
    
}

extension SearchTableView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        return cell
    }


}

