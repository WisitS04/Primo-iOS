


import UIKit
import Alamofire

class MyCard_ViewController: UITableViewController
{
    
    @IBOutlet var MyCardTable: MyCard_TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CheckVertionCardDB
         self.navigationController?.navigationBar.isTranslucent = false
        _ = CardDB.instance.CheckVertionCardDB()

        
        MyCardTable.allowsSelection = false
        MyCardTable.Setup(tableType: .memberCard ,mView: self.view)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "back"){
//            Alamofire.SessionManager.default.session.invalidateAndCancel()
//        }
//    }

}

