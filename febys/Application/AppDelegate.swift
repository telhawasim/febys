//
//  AppDelegate.swift
//  febys
//
//  Created by Waseem Nasir on 23/06/2021.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import PayPalCheckout
import Firebase
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import Braintree
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    static var shared : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.febysBlack()
    
        ZendeskManager.shared.initialize()
        
        setupGoogleCloud()
        registerRemotePushNotifiation(application)
        setupPaypalReturnURL()
        setUserFlow()
        BTAppContextSwitcher.setReturnURLScheme("com.hexagram.febys.payments")

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        var handled: Bool
        
        //---> GoogleSignIn
        handled = GIDSignIn.sharedInstance.handle(url)
        
        //---> FacebookSignIn
        handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        
        return handled
    }
    
    //MARK:  PUSH NOTIFICATIONS
    func registerRemotePushNotifiation(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        NotificationCenter.default.post(name: .notificationUpdated, object: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        RedirectionManager.shared.gotoHome(redirection: .notification)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
        
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "")
        if UserDefaults.isKeyPresentInUserDefaults(key: Constants.kFirebaseToken) {
            if(FirebaseManager.shared.getFirebaseToken() != fcmToken) {
                sendTokenToServer()
            }
        } else {
            FirebaseManager.shared.saveFirebaseToken(token: fcmToken ?? "")
            sendTokenToServer()
        }
    }
    
    func sendTokenToServer() {
        
    }
       
    //MARK: GOOGLE CLOUD CONFIG

    func setupGoogleCloud() {
        GMSServices.provideAPIKey(ConfigurationManager.shared.infoForKey(.googleMapsAPI) ?? "")
        GMSPlacesClient.provideAPIKey(ConfigurationManager.shared.infoForKey(.googlePlacesAPI) ?? "")
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    //MARK: PAYPAL CONFIG
    func setupPaypalReturnURL() {
        let config = CheckoutConfig(
            clientID: PayPalService.clientId,
            returnUrl: PayPalService.returnUrl,
            environment: .sandbox
        )
        Checkout.set(config: config)
    }
    
    //MARK: - CHECK LOGIN
    func setUserFlow() {
        RedirectionManager.shared.gotoHome()
    }
}

