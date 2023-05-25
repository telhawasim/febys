//
//  NotificationService.swift
//  febys
//
//  Created by Faisal Shahzad on 10/02/2022.
//

import Foundation

class NotificationService {
    
    static let shared = NotificationService()
    private init() { }
    
    func fetchNotifications(body info: [String:Any], params: [String: Any], onComplete: @escaping ((Result<NotificationResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Notifications.allNotifications.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func updateNotificationBadge() {
        let urlString = URLHelper.shared.getURLString(with: URI.Notifications.updateBadge.rawValue)
        NetworkManager.shared.sendRequest(method: .PATCH, urlString, body: [:]) { (_, _, _, _) in }
    }
    
    func updateNotificationStatus(of id: String) {
        var urlString = URLHelper.shared.getURLString(with: URI.Notifications.updateStatus.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.NOTIFICATION_ID, with: "\(id)")
        NetworkManager.shared.sendRequest(method: .PATCH, urlString, body: [:]) { (_, _, _, _) in }
    }
}

