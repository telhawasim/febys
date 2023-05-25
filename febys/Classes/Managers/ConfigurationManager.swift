//
//  ConfigurationManager.swift
//  febys
//
//  Created by Waseem Nasir on 25/06/2021.
//

import Foundation

class ConfigurationManager: NSObject {
    
    static var shared = ConfigurationManager()
    private override init() {
        
    }
    
    func infoForKey(_ key: ConfigurationKey) -> String? {
        return (Bundle.main.infoDictionary?[key.rawValue] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}

enum ConfigurationKey: String {
    case baseURL = "baseURL"
    case baseURLConfig = "baseURLConfig"
    case baseURLAuth = "baseURLAuth"
    case baseURLSearch = "baseURLSearch"
    case clientSecret = "clientSecret"
    case googleMapsAPI = "googleMapsAPI"
    case googlePlacesAPI = "googlePlacesAPI"
    case clientID = "clientID"
    case zendeskUrl = "zendeskUrl"
    case zendeskAccountKey = "zendeskAccountKey"
    case zendeskAppId = "zendeskAppId"
    case zendeskClientKey = "zendeskClientKey"
}
