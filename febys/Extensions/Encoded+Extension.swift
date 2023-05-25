//
//  Encoded+Extension.swift
//  febys
//
//  Created by Faisal Shahzad on 04/08/2022.
//

import Foundation

//extension Encodable {
//  func toDictionary() throws -> [String: Any] {
//    let data = try JSONEncoder().encode(self)
//    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//      throw NSError()
//    }
//    return dictionary
//  }
//
//    
//}


extension Encodable {
  var toDictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
