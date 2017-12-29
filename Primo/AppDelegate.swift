//
//  AppDelegate.swift
//  Primo
//
//  Created by Macmini on 12/21/2559 BE.
//  Copyright © 2559 Chalee Pin-klay. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import GoogleSignIn
import FBSDKLoginKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate, GIDSignInDelegate ,MessagingDelegate{



    var window: UIWindow?

    var dUserInfo: String?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {


        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().shadowImage = UIImage(named : "line_header")
        UINavigationBar.appearance().setBackgroundImage(UIImage(named : "line_header"), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        

        
        // Check Internet
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()


        
        
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
//                if error != nil{
//
//                }else{
//                    UNUserNotificationCenter.current().delegate = self
//                    Messaging.messaging().delegate = self
//
//                    DispatchQueue.main.async {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//
//
//            }
//
//        } else {
//            // Fallback on earlier versions
//        }
        


        
        
        FirebaseApp.configure()
        
        
        //Google Login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook Login
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = PlaceViewController()

        return true
    }
    
    

    func ConnectToFCM(){
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let token = InstanceID.instanceID().token() {
            print("DCS: " + token)
        }
        
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ConnectToFCM()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        ConnectToFCM()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        let title = userInfo["title"] as! String
        let subtitle = userInfo["subtitle"] as! String
        let type = userInfo["type"] as! String

        let number = NotificationDB.instance.getNotification().count

        if(number < 10){
             _ = NotificationDB.instance.add(cNotificationId: Int64(number), cImageUrl: "", cTitleName: title, cSubTitleName: subtitle, cType: Int(type)!)
        }else{
            _ = NotificationDB.instance.deleteItem(cId: Int64(number))
            _ = NotificationDB.instance.add(cNotificationId: Int64(number), cImageUrl: "", cTitleName: title, cSubTitleName: subtitle, cType: Int(type)!)
        }


//        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        let number = NotificationDB.instance.getNotification().count
//        let result =  NotificationDB.instance.add(cNotificationId: Int64(number), cImageUrl: "", cTitleName: "title", cSubTitleName: "subtitle", cType: Int(1))
//        print(userInfo)
//    }

    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Set number  notification not read
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        let userInfo = notification.request.content.userInfo
//        saveNotification(data: userInfo as [NSObject : AnyObject])
        let title:  String = userInfo["title"] as! String
        let subtitle: String = userInfo["subtitle"] as! String
        let type: String = userInfo["type"] as! String
        
        let number = NotificationDB.instance.getNotification().count
        
        if(number < 10){
            _ = NotificationDB.instance.add(cNotificationId: Int64(number), cImageUrl: "", cTitleName: title, cSubTitleName: subtitle, cType: Int(type)!)
        }else{
            _ = NotificationDB.instance.deleteItem(cId: Int64(number))
            _ = NotificationDB.instance.add(cNotificationId: Int64(number), cImageUrl: "", cTitleName: title, cSubTitleName: subtitle, cType: Int(type)!)
        }

        

        
        completionHandler([.alert, .badge, .sound ])
        


//        print(userInfo)
//        if let aps = userInfo["aps"] as? NSDictionary {
//              print(aps)
//            if let alert = aps["alert"] as? NSDictionary {
//                print(alert)
//                if let alertMessage = alert["body"] as? String {
//                    print(alertMessage)
//                }
//            }
//
//        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mobi.primo.app.ios"), object: nil)
    }
    


    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        let GoogleUrl = GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: [:])

        let FacebookUrl = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
//        let FacebookUrl = FBSDKApplicationDelegate
//            .sharedInstance().application(application, open: url, sourceApplication: options[.sourceApplication], annotation: options[.annotation])

        return  GoogleUrl || FacebookUrl

    }
  
    
    //Google login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }

            }
        }
 
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
          print("signout Google Account")
    }
    
    
    
    //Facebook login below iOS 10
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        return handled
    }

}
