
import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func OnMailButtonClicked(_ sender: Any) {
        let mailUrl = URL(string: "message://info@Primo.mobi")!
        if UIApplication.shared.canOpenURL(mailUrl) {
            UIApplication.shared.openURL(mailUrl)
        }
    }
    
    @IBAction func OnFbButtonClicked(_ sender: Any) {
//        let fbApp = URL(string: "fb://profile/533684809992041")!
        let fbUrl = URL(string: "https://www.facebook.com/primoapp")!
//        if UIApplication.shared.canOpenURL(fbApp) {
//            UIApplication.shared.openURL(fbApp)
//        }
        if UIApplication.shared.canOpenURL(fbUrl) {
            UIApplication.shared.openURL(fbUrl)
        }
    }
}
