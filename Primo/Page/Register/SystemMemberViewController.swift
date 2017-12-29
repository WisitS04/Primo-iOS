//
//  SystemMemberViewController.swift
//  Primo
//
//  Created by spoton on 28/12/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class SystemMemberViewController: UIViewController
{
    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Register: UIButton!
    @IBOutlet weak var FacebookLogin: FBSDKLoginButton!

    @IBOutlet weak var FacebookView: UIView!
    var authListener: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButton()
        FacebookLogin.readPermissions = ["public_profile", "email"]
        FacebookLogin.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let _ = user {
                    self.FacebookView.backgroundColor = UIColor.clear
                    self.navigationItem.title = user?.email
                
                    let alert = UIAlertController(title: "Login success", message: user?.email, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
               
            }else{
                 self.navigationItem.title = ""
                let alert = UIAlertController(title: "Logout success", message: "Finish", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authListener!)
    }
    
    
}

extension SystemMemberViewController : GIDSignInUIDelegate{
    fileprivate func setupGoogleButton(){
//        let GoogleBtn = GIDSignInButton()
//        GoogleBtn.frame = CGRect(x: 0, y: 0, width: ViewGoogle.bounds.width, height: ViewGoogle.bounds.height)
//        ViewGoogle.backgroundColor = UIColor.clear
//        FacebookView.backgroundColor = UIColor.clear
//        ViewGoogle.addSubview(GoogleBtn)
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()

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
    
}

extension SystemMemberViewController: FBSDKLoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            let alert = UIAlertController(title: "Error Facebook Login", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
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


extension SystemMemberViewController{
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

