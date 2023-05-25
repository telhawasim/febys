//
//  NotificationRouste.swift
//  febys
//
//  Created by Faisal Shahzad on 10/02/2022.
//

import Foundation

extension URI{
    enum Notifications :String {
        case allNotifications = "consumers/notifications/list"
        case updateBadge = "consumers/notifications/mark-read/badge"
        case updateStatus = "consumers/notifications/mark-read/NOTIFICATION_ID"
    }
}

