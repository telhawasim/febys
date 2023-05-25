//
//  WebViewViewController.swift
//  febys
//
//  Created by Nouman Akram on 16/12/2021.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var navbarTitleLabel: FebysLabel!
    @IBOutlet weak var uiView: UIView!
    
    //MARK: Variable
    var webView: WKWebView!
    var urlString: String?
    var titleName: String?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let userScript = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let wkUController = WKUserContentController()
//        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        webView = WKWebView(frame: self.uiView.bounds, configuration: wkWebConfig)
        webView.backgroundColor = .white
        self.uiView.addSubview(webView)
        self.navbarTitleLabel.text = titleName?.capitalized ?? ""
    
        if let url = urlString {
            let request = URLRequest(url: URL(string: url)!)
            webView.load(request)
        }
    }
}
