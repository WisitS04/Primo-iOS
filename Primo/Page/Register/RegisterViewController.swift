//
//  File.swift
//  Primo
//
//  Created by spoton on 21/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class Register: UIViewController, GIDSignInUIDelegate ,FBSDKLoginButtonDelegate
{

    


    @IBOutlet weak var edt_Userid: UITextField!
    @IBOutlet weak var edt_Password: UITextField!
    
    @IBOutlet weak var BtnRegister: UIButton!
    

    @IBOutlet weak var GoogleLogin: GIDSignInButton!
    @IBOutlet weak var FacebookLogin: FBSDKLoginButton!
    
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var BtnLogout: UIButton!
    
    var authListener: AuthStateDidChangeListenerHandle?

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

        
        BtnRegister.addTarget(self, action: #selector(regisBtn), for: .touchUpInside)
        btnLogIn.addTarget(self, action: #selector(login), for: .touchUpInside)
        BtnLogout.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        FacebookLogin.readPermissions = ["public_profile", "email"]
        FacebookLogin.delegate = self
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }

        
   
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let _ = user {

                let alert = UIAlertController(title: "Finish", message: "Login success", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                self.edt_Userid.resignFirstResponder()
                self.edt_Password.resignFirstResponder()
                
            }else{
                let alert = UIAlertController(title: "Finish", message: "Logout success", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                self.edt_Userid.resignFirstResponder()
                self.edt_Password.resignFirstResponder()
            }
        })
        
       
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authListener!)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            let alert = UIAlertController(title: "Error Google Login", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Google Login", message: "Finish", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Firebase Create Google Accout Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            let alert = UIAlertController(title: "Finish", message: "Facbook Login success", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Firebase Create Google Accout Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let alert = UIAlertController(title: "Facbook", message: "logout success", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      
    }

    
}

extension Register{
    @objc func regisBtn(_ sender: Any)  {
        Auth.auth().createUser(withEmail: edt_Userid.text!, password: edt_Password.text!) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func login(_ sender: Any)  {
        Auth.auth().signIn(withEmail: edt_Userid.text!, password: edt_Password.text!) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func logout(_ sender: Any)  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
            let alert = UIAlertController(title: "signing out", message: "Error signing out", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

    
    
}


