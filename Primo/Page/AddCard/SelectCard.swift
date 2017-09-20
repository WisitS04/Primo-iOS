
import UIKit

class SelectCard: UIViewController
{
    
    @IBOutlet weak var done_btn: GreenButton!
    @IBOutlet weak var cardResultTable: CardTableView!
    let searchController = UISearchController(searchResultsController: nil)
    var BankID: Int?
    var CardType: Int?
    var CardTypeName: String?
    
    var mySearchBar: UISearchBar!
    var myLabel : UILabel!
    var searchText: String!
    
    var statusSearch: Bool = false
    var allCard = [CardResult]()
    var filteredCard = [CardResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCardType()
        setupHeaderBar()
        setHeaderTableCard()
        
        //Hide top spat for Table View
        cardResultTable.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false

        
//        done_btn.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        
        cardResultTable.SetUp(viewController: self)
        self.cardResultTable.LoadData(bankId: BankID!,
                                      cardType: CardType!,
                                      cardNetwork: 0)
       
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "Profile Settings"
        
    }
    

    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
}


extension SelectCard{
    
    func setupHeaderBar(){
        self.navigationItem.titleView = nil
        self.navigationItem.setHidesBackButton(false, animated:true);
        self.navigationItem.title = CardTypeName
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(clickSearch)), animated: false)
    }
    
    @objc func clickSearch(_ sender: Any){
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationItem.rightBarButtonItem = nil
        cardResultTable.reloadData()
        setUpSearchBar()
    }
    
    
    func checkCardType(){
        if(CardType == PrimoCardType.creditCard.rawValue){
            CardTypeName = "บัตรเครดิต"
        }else if(CardType == PrimoCardType.debitCard.rawValue){
            CardTypeName = "บัตรเดบิต"
        }else{
            CardTypeName = "บัตรสมาชิก"
        }
    }
    
    func setHeaderTableCard(){
         myLabel = UILabel()
         myLabel.frame = CGRect(x: 0, y: 30, width: 350, height: 30)
         myLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y: 100)
         myLabel.textColor = HexStringToUIColor(hex: PrimoColor.Smoke.rawValue)
         myLabel.text = "  ประเภท"
        self.cardResultTable.tableHeaderView = myLabel
    }
    
}

extension SelectCard :UISearchBarDelegate ,UISearchResultsUpdating {

    
    func setUpSearchBar(){
        
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRect(x: 0, y: 0, width: 350, height: 80)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 100)

        mySearchBar.layer.masksToBounds = false
        mySearchBar.showsCancelButton = true
        mySearchBar.showsBookmarkButton = false
        mySearchBar.searchBarStyle = UISearchBarStyle.default
        mySearchBar.placeholder = "ค้นหาบัตรของคุณ"
        mySearchBar.showsSearchResultsButton = false
        self.navigationItem.titleView = mySearchBar
        
    }
    
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        myLabel.text = searchText
        filterContentForSearchText(searchText:searchText)
    }
    

    
    func updateSearchResults(for searchController: UISearchController) {
         filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCard = allCard.filter { place in
            return (place.nameEN.lowercased().contains(searchText.lowercased()))
                || (place.nameTH.lowercased().contains(searchText.lowercased()))
        }
        if(searchText.length > 0){
            statusSearch = true
        }else{
            statusSearch = false
        }
        self.cardResultTable.reciveDataFiter(list: filteredCard , statusSearch: statusSearch)
        
        cardResultTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty)! {
            searchText = searchBar.text!
        }
        mySearchBar.endEditing(true)
        cardResultTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCard.removeAll()
        self.cardResultTable.reciveDataFiter(list: filteredCard , statusSearch: false)
        cardResultTable.reloadData()
    
        searchText = ""
        mySearchBar.isHidden = true
        mySearchBar = nil
        setupHeaderBar()
        cardResultTable.reloadData()
    }
}


extension SelectCard{
    func OnSelectAllCard(list : [CardResult]  ){
        allCard = list
    }
    
//    @objc func sendActionData(_ sender: UIButton!)  {
//      self.navigationController?.popViewController(animated: true)
//    }
    

}
