//
//  ResponseManager.swift
//  febys
//
//  Created by Waseem Nasir on 29/06/2021.
//

import Foundation

class ResponseManager {
    static let shared = ResponseManager()
    
    private init() {}
    
    func decode<T:Codable>(data: Data?, response: URLResponse?, error: Error?, onComplete: @escaping ((Result<T, FebysError>)->Void)){
        if let data = data{
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    onComplete(.success(response))
                }
            }
            catch let error {
                onComplete(.failure(FebysError.error(error.localizedDescription)))
                print(error)
            }
        }
    }
    
}
