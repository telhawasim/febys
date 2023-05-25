//
//  URI.swift
//  febys
//
//  Created by Waseem Nasir on 25/06/2021.
//

import Foundation

struct URI: Codable {
    private init() { }
    
}

class URLHelper {
    static let shared = URLHelper()
    private let baseURL = ConfigurationManager.shared.infoForKey(.baseURL) ?? "https://"
    private let baseURLAuth = ConfigurationManager.shared.infoForKey(.baseURLAuth) ?? "https://"
    private let baseURLConfig = ConfigurationManager.shared.infoForKey(.baseURLConfig) ?? "https://"
    private let baseURLSearch = ConfigurationManager.shared.infoForKey(.baseURLSearch) ?? "https://"


    func getBaseURLString(with url: String) ->String {
        return baseURL + "/api/" + url
    }
    
    func getURLString(with url: String, version:String = "v1") ->String {
        return baseURL + "/api/" + version + "/" + url
    }
    
    func getConfigURLString(with url: String, version:String = "v1") ->String {
        return baseURLConfig + "/" + version + "/" + url
    }
    
    func getAuthURLString(with url: String) -> String {
        return baseURLAuth + "/realms/" + url
    }
    
    func getSearchURLString(with url: String = "") -> String {
        return baseURLSearch + url
    }
}
