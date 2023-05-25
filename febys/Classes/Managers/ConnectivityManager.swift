//
//  ConnectivityManager.swift
//  febys
//
//  Created by Waseem Nasir on 25/06/2021.
//

import Foundation
import Network

class ConnectivityManager {
    static let shared = ConnectivityManager()
    
    var isConnected = false
    
    private let monitor = NWPathMonitor()
    
    private init() {
        guard monitor.pathUpdateHandler == nil else { return }
         
         monitor.pathUpdateHandler = { update in
            self.isConnected = update.status == .satisfied ? true : false
         }
         
         monitor.start(queue: DispatchQueue(label: "InternetMonitor"))
    }
    
}
