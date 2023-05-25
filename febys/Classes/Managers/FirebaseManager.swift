//
//  FirebaseManager.swift
//  febys
//
//  Created by Faisal Shahzad on 10/02/2022.
//

import Foundation
import FirebaseMessaging

class FirebaseManager: NSObject {
    
    static var shared = FirebaseManager()
    
    //MARK: Saving firebase token
    func saveFirebaseToken(token : String) {
        UserDefaults.standard.set(token, forKey: Constants.kFirebaseToken)
    }
    
    func getFirebaseToken() -> String {
        return UserDefaults.standard.string(forKey: Constants.kFirebaseToken) ?? ""
    }
    
    //MARK: Topic Subscription/Unsubscription
    func subscribeToTopic(_ topic: Int) {
        Messaging.messaging().subscribe(toTopic: "\(topic)") { error in
            if error == nil {
                print("Subscribed to FCM topic: ", topic)
            } else {
                print("FCM Error: ", error ?? "")
            }
        }
    }
    
    func unSubscribeToTopic(_ topic: Int) {
        Messaging.messaging().unsubscribe(fromTopic: "\(topic)") { error in
            if error == nil {
                print("Unsubscribed to FCM topic: ", topic)
            } else {
                print("FCM Error: ", error ?? "")
            }
        }
    }
}
