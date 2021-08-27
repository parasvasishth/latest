//
//  AppDelegate.swift
//  Stumbal
//
//  Created by mac on 17/03/21.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleSignIn
import FBSDKCoreKit
import FirebaseCore
import FirebaseMessaging
//GIDSignInDelegate
@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate,UNUserNotificationCenterDelegate{

var window: UIWindow?
let gcmMessageIDKey = "gcm_MessageID_Key"
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    IQKeyboardManager.shared.enable = true
    GMSPlacesClient.provideAPIKey("AIzaSyCP7aBsWcyQv1JKVF9vQKP8M_PRk3iB2W0")
    if #available(iOS 13.0, *) {
       // Always adopt a light interface style.
       window?.overrideUserInterfaceStyle = .light
    }
    
    if UserDefaults.standard.bool(forKey: "login")
    {
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : SWRevealViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
    }
    else
    {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : LoginVC = mainStoryboardIpad.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
        
    }
    print("SDK version \(Settings .sdkVersion)")

    //   For Facebook
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    //
    // Initialize sign-in
    GIDSignIn.sharedInstance().clientID = "23039904043-7qhmjvvvhtg4c4sf0k1a4cuf2h4ebd3a.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
    
    
    
    // firebase notification
    let center  = UNUserNotificationCenter.current()
    center.delegate = self
    
    //Set the type as sound or badge
    center.requestAuthorization(options: [.sound,.alert]) { (granted, error) in
        
        // Enable or disable features based on authorization
        
    }
    application.registerForRemoteNotifications()
    
    // Use Firebase library to configure APIs
    FirebaseApp.configure()
    
    Messaging.messaging().delegate = self
    
    
    return true
}

   
//MARK: Getting Notification When App in Foreground
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
    
    let userInfo = notification.request.content.userInfo as? NSDictionary
    print("\(userInfo)")
    completionHandler( [.alert, .badge, .sound])
    if let aps = userInfo!["aps"] as? NSDictionary {
        if let alert = aps["alert"] as? NSDictionary {
            if let title = alert["body"] as? NSString {
                if title == "Vendor Request for pickup order "{
                    
                }
            }else{
                
            }
        } else if let alert = aps["alert"] as? NSString {
            //Do stuff
        }
    }
    
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }
    
    // Print full message.
    print(userInfo)
    
    completionHandler(UIBackgroundFetchResult.newData)
}

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
          withError error: Error!) {
    if let error = error {
        print("\(error.localizedDescription)")
    } else {
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...
    }
}

func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
          withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
    // ...
}

//For Facebook
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
    let handled: Bool = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    // Add any custom logic here.
    return handled
}
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//            let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
//
//            return handled
//        }

}

extension AppDelegate:MessagingDelegate
{
func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    
    print("1111",String(fcmToken!))
    
    
    UserDefaults.standard.set(String(fcmToken!), forKey: "devicetoken")
    
    // UserDefaults.standard.set(deviceTokenString, forKey: "devicetoken")
    
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}
}

//extension AppDelegate:UNUserNotificationCenterDelegate
//{
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//      let userInfo = notification.request.content.userInfo
//
//      Messaging.messaging().appDidReceiveMessage(userInfo)
//
//
//      // Change this to your preferred presentation option
//      completionHandler([[.alert, .sound]])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//      let userInfo = response.notification.request.content.userInfo
//
//      Messaging.messaging().appDidReceiveMessage(userInfo)
//
//      completionHandler()
//    }
//
////    func application(_ application: UIApplication,
////    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
////       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
////      Messaging.messaging().appDidReceiveMessage(userInfo)
////      completionHandler(.noData)
////    }
//
//}

