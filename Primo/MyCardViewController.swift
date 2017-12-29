
import UIKit

class MyCardViewController: UIViewController {

    @IBOutlet weak var creditCardTableView: MyCardTableView!
    @IBOutlet weak var memberCardTableView: MyCardTableView!
    
    @IBOutlet weak var creditEditButton: GreenButton!
    @IBOutlet weak var memberEditButton: GreenButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creditCardTableView.Setup(tableType: .creditCard)
        memberCardTableView.Setup(tableType: .memberCard)
        
        navigationController?.delegate = self
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func OnEditCreditCardButtonClicked(_ sender: Any) {
        creditCardTableView.ToggleEditMode()
        if (creditCardTableView.isOnEditing) {
            creditEditButton.setTitle("DONE", for: .normal)
        } else {
            creditEditButton.setTitle("EDIT", for: .normal)
        }
    }
    
    @IBAction func OnEditMemberCardButtonClicked(_ sender: Any) {
        memberCardTableView.ToggleEditMode()
        if (memberCardTableView.isOnEditing) {
            memberEditButton.setTitle("DONE", for: .normal)
        } else {
            memberEditButton.setTitle("EDIT", for: .normal)
        }
    }
}

extension MyCardViewController: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (viewController == self && isViewLoaded) {
            creditCardTableView.UpdateMyCards()
            memberCardTableView.UpdateMyCards()
        }
    }
}
