//
//  SignIn.swift
//  Primo
//
//  Created by spoton on 28/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var txt_title: UILabel!
    @IBOutlet weak var txt_eamil: UILabel!
    @IBOutlet weak var txt_password: UILabel!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_password: UITextField!
    
    @IBOutlet weak var btn_signIn: GreenButton!
    @IBOutlet weak var btn_fogetpassword: UIButton!
    @IBOutlet weak var btn_showpassword: UIButton!
    
      var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edt_password.isSecureTextEntry = true
        btn_signIn.addTarget(self, action: #selector(login), for: .touchUpInside)
        btn_showpassword.addTarget(self, action: #selector(showpassword), for: .touchUpInside)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let _ = user {
                self.navigationItem.title = user?.email
                let alert = UIAlertController(title: "Login success", message: user?.email, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                self.navigationItem.title = "please Login or register"
            }
        })
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authListener!)
    }
}

extension SignInViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension SignInViewController{
    @objc func login(_ sender: Any)  {
        Auth.auth().signIn(withEmail: edt_email.text!, password: edt_password.text!) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func showpassword(_ sender: Any)  {
        
        if(edt_password.isSecureTextEntry) {
            edt_password.isSecureTextEntry = false
        } else {
            edt_password.isSecureTextEntry = true
        }
    }
    
}

