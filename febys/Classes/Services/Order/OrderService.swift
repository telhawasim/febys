//
//  OrderService.swift
//  febys
//
//  Created by Faisal Shahzad on 03/10/2021.
//

import Foundation

class OrderService {
    static let shared = OrderService()
    var orders: [OrderLocal]
    
    init() { orders = [] }
    
    func fetchOrderInfo(body info: [String: Any] = [:], params: [String: String] = [:], onComplete: @escaping ((Result<OrderResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Order.orderInfo.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func placeOrder(body info: [String: Any], headers: [String: String] = [:], onComplete: @escaping ((Result<OrderResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Order.placeOrder.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, headers: headers) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchOrderListing(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<OrderResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Order.orderList.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchOrderBy(id: String, body info: [String: Any] = [:], headers: [String: String] = [:], onComplete: @escaping ((Result<OrderResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Order.orderById.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")

        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func cancelOrderBy(id: String, of vendorId: String, body info: [String: String], headers: [String: String] = [:], onComplete: @escaping ((Result<OrderResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Order.cancelOrder.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.ORDER_ID, with: "\(id)")
        urlString = urlString.replacingOccurrences(of: Constants.VENDOR_ID, with: "\(vendorId)")

        NetworkManager.shared.sendRequest(method: .PATCH, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchCancelReasons(onComplete: @escaping ((Result<ReasonsResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Order.cancelReasons.rawValue)
        NetworkManager.shared.sendGetRequest(urlString){(data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchReturnReasons(onComplete: @escaping ((Result<ReasonsResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Order.returnReasons.rawValue)
        NetworkManager.shared.sendGetRequest(urlString){(data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func returnOrderBy(id: String, body info: [String:Any], onComplete: @escaping ((Result<OrderResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.Order.returnOrder.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.ORDER_ID, with: "\(id)")

        NetworkManager.shared.sendRequest(method: .PATCH, urlString, body: info){(data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
