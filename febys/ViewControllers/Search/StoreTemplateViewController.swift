//
//  StoreTemplateViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 16/12/2021.
//

import UIKit
import WebKit

class StoreTemplateViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var navbarTitleLabel: FebysLabel!
    @IBOutlet weak var uiView: UIView!

    //MARK: Properties
    var webView: WKWebView!
    var titleName: String?
    var templateId: String?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let userScript = WKUserScript(source: scriptContent, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        webView = WKWebView(frame: .zero, configuration: wkWebConfig)
        webView.backgroundColor = .white
        
        self.uiView.addSubview(webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.topAnchor.constraint(equalTo:   self.uiView.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.uiView.bottomAnchor).isActive = true
        self.webView.leadingAnchor.constraint(equalTo: self.uiView.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.uiView.trailingAnchor).isActive = true

        self.navbarTitleLabel.text = titleName?.capitalized ?? ""
        if let id = templateId { self.fetchStoresTemplateBy(id: id) }
    }
    
    
    //MARK: API Calling
    func fetchStoresTemplateBy(id: String) {
        Loader.show()
        TemplateService.shared.fetchStoreTemplateBy(id: id) { response in
            Loader.dismiss()
            switch response{
            case .success(let template):
                if let content = template.content {
                    self.webView.loadHTMLString(content, baseURL: nil)
                }
                self.webView.reload()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}
