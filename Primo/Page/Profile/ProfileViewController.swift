import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileVIew: UIView!
    @IBOutlet weak var txt_profile: UILabel!
    
    @IBOutlet weak var MyCardView: UIView!
    @IBOutlet weak var txt_myCard: UILabel!
    
    @IBOutlet weak var FeedbackView: UIView!
    @IBOutlet weak var txt_feedback: UILabel!
    @IBOutlet weak var contectView: UIView!
    @IBOutlet weak var txt_contrct: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToMyCard))
        gesture.numberOfTapsRequired = 1
        MyCardView?.isUserInteractionEnabled = true
        MyCardView?.addGestureRecognizer(gesture)
        
        
    }
    
    
}

extension ProfileViewController{
    @objc func goToMyCard(_ sender: Any)  {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCard_ViewController") as! MyCard_ViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
