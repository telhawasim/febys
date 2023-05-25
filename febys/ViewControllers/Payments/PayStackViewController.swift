//
//  PayStackViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 13/01/2022.
//

import UIKit
import WebKit

enum PayStackSupportedCurrencies: String{
    case NGN
    case GHS
    case ZAR
//    case USD
}

class PayStackViewController: BaseViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var webView: WKWebView!
    
    
    // MARK: PROPERTIES
    var popupWebViews: [WKWebView]?
    var payStack: PayStackResponse?

    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let urlString = payStack?.transactionRequest?.authorization_url,
           let url = URL(string: urlString){
            webView.load(URLRequest(url: url))
            checkTransactionStatus()
        }else{
            print("Invalid url in \(self)") // --- This should never be called
        }
    }
    
    // MARK: API CALLS
    func checkTransactionStatus() {
        PurchaseService.shared.checkPayStackStatus(payStack: payStack) { [weak self] response in
            switch response{
            case .success(let transactionId):
                if transactionId == "", self?.viewIfLoaded?.window != nil{ // --- If view is visible and transaction is not completed yet
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.checkTransactionStatus()
                    }
                }else{
                    self?.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print("error checkTransactionStatus \(error.localizedDescription)")
            }
        }
    }
}

// MARK: WEBVIEW MULTI WINDOW HANDLING
extension PayStackViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView.navigationDelegate = self
        popupWebView.uiDelegate = self
        popupWebView.backgroundColor = .white
        popupWebViews?.append(popupWebView)
        view.addSubview(popupWebView)
        return popupWebView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebViews?.removeAll(where: {$0 == webView})
    }
}

extension PayStackViewController: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
