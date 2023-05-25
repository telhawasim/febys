//
//  ProductDescriptionCell.swift
//  febys
//
//  Created by Waseem Nasir on 13/07/2021.
//

import UIKit
import WebKit

class ProductDescriptionCell: UITableViewCell, WKNavigationDelegate {
    // MARK:- OUTLETS
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var pageControl: CustomPageControl!
    
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: WKWebView!
    // COLLECTIONVIEW PROPERTIES
    private let numberOfItemPerRow = 1
    private let screenWidth = UIScreen.main.bounds.width
    private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let minimumInteritemSpacing = CGFloat(1)
    private let minimumLineSpacing = CGFloat(1)
    
    let htmlCode = "<ul>\n\t<li>Rotating, noise canceling microphone. Sensitivity (headphone) 94 dBV/Pa +/ 3 dB. Sensitivity (microphone) 17 dBV/Pa +/ 4 dB</li>\n\t<li>Convenient inline volume and mute controls</li>\n\t<li>Advanced digital USB, connections: USB compatible (1.1 and 2.0)</li>\n\t<li>Compatible with Windows Vista, Windows 7, Windows 8, Windows 10 or later and Mac OS X(10.2.8 or later)</li>\n\t<li>2 Year Limited warranty</li>\n</ul>\n"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        webView.navigationDelegate = self
        webView.loadHTMLString(htmlCode, baseURL: nil)
        
//        collectionView.register(UINib(nibName: ProductImagesCell.className, bundle: nil), forCellWithReuseIdentifier: ProductImagesCell.className)

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
//        webView.scrollView.isScrollEnabled=false;
        webViewHeightConstraint.constant = webView.scrollView.contentSize.height
//        webView.scalesPageToFit = true
//        webView.scale
        
        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        
        let fittingSize = webView.sizeThatFits(CGSize(width: 0, height: 0))
        frame.size = fittingSize
        webView.frame = frame
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
    }
    
//    func configure(category: Categories?){
//        self.mainLabel.text = category?.name ?? ""
//    }
    
}
