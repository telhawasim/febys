//
//  VoucherService.swift
//  febys
//
//  Created by Faisal Shahzad on 10/11/2021.
//

import Foundation

class VoucherService {
    static let shared = VoucherService()
    private init() { }
    
    func fetchVoucher(code: String ,params info: [String: String]=[:], onComplete: @escaping ((Result<VoucherResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Vouchers.getVoucher.rawValue)
        
        urlString = urlString.replacingOccurrences(of: Constants.VOUCHER_CODE, with: "\(code)")
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func collectVoucher(code: String, body info: [String:Any] = [:], onComplete: @escaping ((Result<VoucherResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Vouchers.collectVoucher.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.VOUCHER_CODE, with: "\(code)")
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchVoucherListing(body info: [String:Any]=[:], params: [String:Any] = [:], onComplete: @escaping ((Result<VoucherResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Vouchers.getVouchersList.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
