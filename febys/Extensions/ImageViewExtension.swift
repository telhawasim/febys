//
//  ImageViewExtension.swift
//  Yahuda
//
//  Created by Hira Saleem on 25/06/2021.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    func setImage(url:String, forceRefresh: Bool = false, scaleToFitFrame: Bool = false, placeholder: String = "no-image"){
        let activityInd = UIActivityIndicatorView()
        activityInd.color = UIColor.febysBlack()
        self.addSubview(activityInd)
        activityInd.translatesAutoresizingMaskIntoConstraints = false
        activityInd.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityInd.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        activityInd.startAnimating()
        
        if let urlStr = URL.init(string:url)
        {
            let resource = ImageResource(downloadURL: urlStr)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: forceRefresh ? [.forceRefresh] : nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    activityInd.stopAnimating()
                    if scaleToFitFrame {
                        self.image =  value.image.aspectFitImage(inRect: self.frame)
                    } else {
                        self.image =  value.image
                    }

//                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    
                case .failure(_):
                    activityInd.stopAnimating()
                    self.image = UIImage(named: placeholder)
                    print(urlStr)
//                    print("Error: \(error)")
                }
            }
        }
        
    }
    
    func imageToUrlResult(image : UIImageView, url: String) -> Bool  {
        image.kf.indicatorType = .activity
        var isResult =  false
        
        if let urlStr = URL.init(string:url)
        {
            //            image.kf.setImage(with: urlStr)
            let resource = ImageResource(downloadURL: urlStr)
            
            KingfisherManager.shared.retrieveImage(with: resource, options:   [.forceRefresh], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    isResult =  true
                    image.image =  value.image
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    
                    
                case .failure(let error):
                    isResult = false
                    print(urlStr)
                    print("Error: \(error)")
                }
                
            }
            
            return  isResult
            
            
            //
        }
        return  isResult
        
    }
}

