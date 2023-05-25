//
//  OfferService.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import Foundation

class OfferService {
    static let shared = OfferService()
    
    private init() { }
    
    func homeBanner(params info: [String: String] = [:], onComplete: @escaping ((Result<[HomeBanner], FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getConfigURLString(with: URI.OffersRoutes.banner.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func seasonalOffers(params info: [String: Any] = [:], onComplete: @escaping ((Result<[SeasonalOfferResponse], FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getConfigURLString(with: URI.OffersRoutes.seasonalOffer.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
