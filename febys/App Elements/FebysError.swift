//
//  FebysError.swift
//  febys
//
//  Created by Waseem Nasir on 29/06/2021.
//

import Foundation

class APIErrorHandler {
    static let shared = APIErrorHandler()
    private init() {}
    
    func handleError<T:Codable>(data: Data?, response: URLResponse?, error: Error?, request: URLRequest?, onComplete: @escaping ((Result<T, FebysError>)->Void)) -> Bool{
        if let error = error{
            onComplete(.failure(FebysError.error(error.localizedDescription)))
            return false
        }
        
        guard let res = response as? HTTPURLResponse else {onComplete(.failure(FebysError.error(Constants.SomethingWentWrong))); return false}
        
        switch res.statusCode {
        case 401:
            onComplete(.failure(FebysError.error(Constants.unAuthorized)))
            return false
            
        case 400:
            if let data = data, let apiError = try? JSONDecoder().decode(APIError.self, from: data){
                onComplete(.failure(FebysError.error(apiError.errors?.first?.error ?? apiError.message ?? Constants.SomethingWentWrong)))
            }else{
                onComplete(.failure(FebysError.error(Constants.SomethingWentWrong)))
            }
            return false
        case 404:
            if let data = data, let apiError = try? JSONDecoder().decode(APIError.self, from: data){
                onComplete(.failure(FebysError.error(apiError.errors?.first?.error ?? apiError.message ?? Constants.SomethingWentWrong)))
            }else{
                onComplete(.failure(FebysError.error(Constants.SomethingWentWrong)))
            }
            return false
            
        case 403:
//            ResponseManager.shared.
            TokenManager.shared.handleTokenExpiry(with: request, onComplete: onComplete)
            return false
            
        case 502:
            onComplete(.failure(FebysError.error(Constants.SomethingWentWrong)))
            return false
        default:
            return true
        }
    }
}

enum FebysError: Error {
    case error(_ message: String)
}

extension FebysError {
    var localizedDescription: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}
