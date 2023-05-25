//
//  Navigation.swift
//  febys
//
//  Created by Waseem Nasir on 01/07/2021.
//

import UIKit

class CustomNavigation: NSObject, UIGestureRecognizerDelegate, UINavigationControllerDelegate{
    
    static let shared = CustomNavigation()
    private override init() { }
    
    func makeNavigation(with viewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: viewController)
        nav.delegate = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.interactivePopGestureRecognizer?.isEnabled = true
        return nav
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let isFirst = viewController == navigationController.viewControllers.first
        navigationController.interactivePopGestureRecognizer?.isEnabled = !isFirst
    }
    
    func updateCurrentNavigation(viewController: UIViewController){
        let nav = viewController.navigationController
        if let nav = nav{
            self.updateCurrentNavigation(nav: nav)
        }
    }
    
    func updateCurrentNavigation(nav: UINavigationController){
        nav.delegate = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        CustomNavigation.shared.updateCurrentNavigation(nav: self)
    }
}
