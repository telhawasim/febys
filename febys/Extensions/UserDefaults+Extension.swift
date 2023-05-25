//
//  UserDefaults+Extension.swift
//  febys
//
//  Created by Faisal Shahzad on 10/02/2022.
//

import Foundation
import UIKit

extension UserDefaults {
    
    static let defaults = UserDefaults.standard
    
    class func setUserDefaults(key : String, value : Any ) {
        if let boolValue = value as? Bool {
            UserDefaults.defaults.set(boolValue, forKey: key)
        }
    }
    
    class func getBoolValueFromUserDefaults(key : String) -> Bool  {
          return UserDefaults.defaults.bool(forKey: key)
    }
    
    class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.defaults.object(forKey: key) != nil
    }
    
    class func saveArchivedDataInUserDefaults(key : String, value : Any ) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value,requiringSecureCoding : false)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            
        }
    }
    
}
