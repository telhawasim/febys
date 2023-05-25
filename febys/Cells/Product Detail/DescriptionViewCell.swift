//
//  DecriptionViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 10/01/2022.
//

import UIKit
import WebKit

class DescriptionViewCell: UIView {
    //MARK: IBOultlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!

    //MARK: Properties
    var webView: WKWebView!
    
    //MARK: Configure
    func configure(_ description: Descriptions){        
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        self.webView = WKWebView(frame: .zero, configuration: wkWebConfig)
        
        
        let content = String(format: "<html><head><style>img{max-width:100%%;height:auto !important;width:auto !important;} body{font-family: Helvatica, Arial; word-wrap:break-word;};</style></head><body style='margin:0; padding:0;'> %@ </body></html>", description.content ?? "")
        
        self.webView.loadHTMLString(content, baseURL: nil)
        self.webView.navigationDelegate = self
        self.webView.scrollView.showsVerticalScrollIndicator = false
        
        self.contentView.addSubview(webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }
}

extension DescriptionViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let scrollableSize = CGSize(width: self.frame.size.width, height: self.webView.scrollView.contentSize.height)
//        self.webView?.scrollView.contentSize = scrollableSize
        self.webView.evaluateJavaScript(
            "(function() {var i = 1, result = 0; while(true){result = document.body.children[document.body.children.length - i].offsetTop + document.body.children[document.body.children.length - i].offsetHeight; if (result > 0) return result; i++}})()", completionHandler: { (height, error) in
                let height = height as? CGFloat
                self.contentViewHeight.constant = (height ?? 0.0) + 20
            }
        )
    }
}
