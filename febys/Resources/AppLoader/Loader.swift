//
//  Loader.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import UIKit

class Loader {
    
    private static var retainCouner = 0
    private static var loader: UIView?
    private static var imageView : UIImageView?
    private static var progressView: UIView?
    private static var textLabel: UILabel?

    
    public static var animationDuration = 0.75 {
        didSet {
            imageView?.animationDuration = animationDuration
            if imageView != nil {
                show()
            }
        }
    }
    
    static func show() {
        
        if retainCouner != 0 {
            retainCouner += 1;
            return;
        }

        loader?.removeFromSuperview()
        loader = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        loader?.translatesAutoresizingMaskIntoConstraints = false
        guard let window = AppDelegate.shared.window else {
            return
        }
        window.addSubview(loader!)
        
        retainCouner += 1;

        loader?.topAnchor.constraint(equalTo: window.topAnchor, constant: 0).isActive = true
        loader?.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0).isActive = true
        loader?.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0).isActive = true
        loader?.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0).isActive = true
        
        loader?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.40);
        animateImages()

    }
    
    
    static func show(on window: UIView) {
     
        loader?.removeFromSuperview()
        loader = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        loader?.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(loader!)
        loader?.topAnchor.constraint(equalTo: window.topAnchor, constant: 0).isActive = true
        loader?.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0).isActive = true
        loader?.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0).isActive = true
        loader?.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0).isActive = true
        
        loader?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.40);
    }
    
    static func dismiss(_ forced : Bool = false) {

        retainCouner -= 1;
        print("dismissCounter = \(retainCouner)")

        if retainCouner > 0 && forced == false {
            return;
        }

        DispatchQueue.main.async {
            imageView?.stopAnimating()
            loader?.removeFromSuperview()
            progressView?.removeFromSuperview()
        }
        
        retainCouner = 0;
    }
    
    private static func animateImages() {
        guard let loader = loader else {
            return
        }
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        loader.addSubview(containerView)
        containerView.widthAnchor.constraint(equalToConstant: 130).isActive = true // image width
        containerView.heightAnchor.constraint(equalToConstant: 130).isActive = true // image height
        containerView.centerXAnchor.constraint(equalTo: loader.centerXAnchor, constant: 0).isActive = true
        containerView.centerYAnchor.constraint(equalTo: loader.centerYAnchor, constant: 0).isActive = true
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView!)
        imageView?.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 5).isActive = true
        
        imageView?.image = UIImage.gif(name: "loader")
    }
}

extension UIImage {

    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

}

extension UIImage {

    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
