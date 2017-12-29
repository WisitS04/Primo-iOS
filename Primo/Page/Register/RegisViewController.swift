//
//  RegisViewController.swift
//  Primo
//
//  Created by spoton on 29/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisViewController: UIViewController {
   
  
    @IBOutlet weak var txt_Title: UILabel!
    @IBOutlet weak var txt_email: UILabel!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var txt_password: UILabel!
    @IBOutlet weak var edt_password: UITextField!
    @IBOutlet weak var txt_repassword: UILabel!
    @IBOutlet weak var edt_repassword: UITextField!
    @IBOutlet weak var txt_sex: UILabel!
    @IBOutlet weak var checkbok_man: UIButton!
    @IBOutlet weak var txt_man: UILabel!
    @IBOutlet weak var checkbox_woman: UIButton!
    @IBOutlet weak var txt_woman: UILabel!
    @IBOutlet weak var checkbox_other: UIButton!
    @IBOutlet weak var txt_other: UILabel!
    @IBOutlet weak var btn_registerMenber: GreenButton!
    @IBOutlet weak var btn_showpassword: UIButton!
    
    var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         edt_password.isSecureTextEntry = true
         edt_repassword.isSecureTextEntry = true
         btn_registerMenber.addTarget(self, action: #selector(regisBtn), for: .touchUpInside)
         btn_showpassword.addTarget(self, action: #selector(showpassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let _ = user {
                self.navigationItem.title = user?.email
                let alert = UIAlertController(title: "Register success", message: user?.email, preferredStyle: UIAlertControllerStyle.alert)
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

extension RegisViewController {

    @objc func showpassword(_ sender: Any)  {
        
        if(edt_password.isSecureTextEntry) {
            edt_password.isSecureTextEntry = false
        } else {
            edt_password.isSecureTextEntry = true
        }
    }

    @objc func regisBtn(_ sender: Any)  {
        if(checkPassword()){
            Auth.auth().createUser(withEmail: edt_email.text!, password: edt_password.text!) { (user, error) in
                if let error = error {
                    let alert = UIAlertController(title: "Firebase error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "เกิดข้อผิดพลาด", message: "Password ไม่ตรงกัน กรุณาลองหใม่อีกครั้ง", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
        
        func checkPassword() -> Bool{
            let status: Bool
            if(edt_password.text == edt_repassword.text){
                status = true
            }else{
                status = false
            }
            return status
        }
    
    func MoveView(edt : UITextField , moveDistance: Int , up :Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame =  CGRect(x: 0, y: movement, width: view.bounds.width, height: view.bounds.height)
        UIView.commitAnimations()
    }
}


extension RegisViewController : UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.tag == 1){
              MoveView(edt: textField, moveDistance:0, up: true)
        }else if(textField.tag == 2){
             MoveView(edt: textField, moveDistance: 0, up: true)
        }else{
             MoveView(edt: textField, moveDistance: -100, up: true)
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        MoveView(edt: textField, moveDistance: 0, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
