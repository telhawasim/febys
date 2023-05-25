//
//  MenuService.swift
//  febys
//
//  Created by Faisal Shahzad on 16/12/2021.
//

import Foundation

class MenuService {
    static let shared = MenuService()
    private init() { }
    
    func fetchAllMenu(params info: [String: Any]=[:], onComplete: @escaping ((Result<[MenuResponse], FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getConfigURLString(with: URI.Menu.getAllMenu.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
