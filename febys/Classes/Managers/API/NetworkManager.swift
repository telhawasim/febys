//
//  NetworkManager.swift
//  febys
//
//  Created by Waseem Nasir on 25/06/2021.
//

import Foundation
import Network
import UIKit

typealias completionHandler = ((Data?, URLResponse?, Error?, URLRequest?)->Void)

enum HTTPMethod:String {
    case POST
    case PATCH
    case PUT
    case DELETE
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    static let monitor = NWPathMonitor()
    
    private override init() {}
    
    var userToken : String? {
        get {
            return User.fetch()?.access_token
        }
    }
    
    func sendGetRequest(_ url: String, params: [String:Any] = [:], headers: [String: Any] = [:], onComplete: @escaping completionHandler) {
        
        var queryParams = ""
        for (key, val) in params {
            queryParams += "&\(key)=\(val)"
        }
        
        let urlStr = url + "?" + queryParams
        let allowed = CharacterSet.whitespacesAndNewlines.inverted
        
        guard let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: allowed)!) else {
            onComplete(nil, nil, nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        for (key, value) in headers {
            request.addValue("\(value)", forHTTPHeaderField: key)
        }
        
        if let accessToken = userToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: Constants.authorization)
        }
        
        self.startURLSession(request: request, onComplete: onComplete);
        
    }
    
    func sendRequest(method: HTTPMethod, _ url: String, body: [String: Any], headers: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping completionHandler) {
        
        var queryParams = ""
        for (key, val) in params {
            queryParams += "&\(key)=\(val)"
        }
        
        let urlStr = url + "?" + queryParams
        let allowed = CharacterSet.whitespacesAndNewlines.inverted
        
        guard let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: allowed)!) else {
            onComplete(nil, nil, nil, nil)
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        for (key, value) in headers {
            request.addValue("\(value)", forHTTPHeaderField: key)
        }
        if let accessToken = userToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: Constants.authorization)
        }
        
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        self.startURLSession(request: request, onComplete: onComplete);
        
    }
    
    func sendURLEncodedRequest(method: HTTPMethod, _ url: String, body: [String: Any], headers: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping completionHandler) {
        
        var queryParams = ""
        for (key, val) in params {
            queryParams += "&\(key)=\(val)"
        }
        
        let urlStr = url + "?" + queryParams
        let allowed = CharacterSet.whitespacesAndNewlines.inverted
        
        guard let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: allowed)!) else {
            onComplete(nil, nil, nil, nil)
            return
        }
                
        var formData = ""
        for (key, val) in body {
            formData += "&\(key)=\(val)"
        }
        
        let bodyData : Data = formData.data(using: .utf8)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.httpBody = bodyData
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.addValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
    
        self.startURLSession(request: request, onComplete: onComplete);
        
    }
    
    func startURLSession(request: URLRequest, didPrint: Bool = true, onComplete: @escaping completionHandler) {
        
        let config = URLSessionConfiguration.default
        //        config.httpAdditionalHeaders = [ParameterKeys.userAgent: Constants.currentAgent]
        
        let session = URLSession(configuration: config)
//        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            
            if data != nil {
                print("### API - NETWORK ###")
                print(request.url?.absoluteString ?? "null invalid url string");
                
                if let requestHeader = request.allHTTPHeaderFields{
                    print("Header : \(String(describing: requestHeader))")
                }
                if didPrint {
                    if let body = request.httpBody {
                        print("Body : \(String(decoding: body, as: UTF8.self))")
                    }
                }
                
                print("Response : ")
                print(String(data: data!, encoding: String.Encoding.utf8) ?? "failed to convert to string");
                print("########################       ################################################################")
            }
            onComplete(data, response, error, request);
            
        }.resume()
    }
    
    func requestNativeImageUpload(_ url: String, parameters: [String: String], image: UIImage, onComplete: @escaping completionHandler ) {
        
        guard let url = URL(string: url) else { return }
        let boundary = generateBoundary()
        var request = URLRequest(url: url)
        
        guard let mediaImage = Media(withImage: image, forKey: "media") else { return }
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        self.startURLSession(request: request, didPrint: false, onComplete: onComplete)
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}

//extension NetworkManager: URLSessionDelegate {
//    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//       //Trust the certificate even if not valid
//       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//       completionHandler(.useCredential, urlCredential)
//    }
//}
