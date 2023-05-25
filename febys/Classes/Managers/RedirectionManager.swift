//
//  RedirectionManager.swift
//  febys
//
//  Created by Waseem Nasir on 09/07/2021.
//

import UIKit

/// class to manage redirection between view controllers
class RedirectionManager: NSObject {
    
    /// shared instance to access RedirectionManager
    static let shared = RedirectionManager()
    private var tabBar: UITabBar?
//    private var tabBarController = UIStoryboard.getVC(from: .Main, "TabBarController") as! UITabBarController
    /// method is declared private to prevent creation of another object of this class. Only way to access its methods would be through `shared` object
    private override init() { }
    
    /// To take user to home screen after login
    ///
    /// Create an object of `UITabBarController` and loads it on  `rootViewController` in `window` in `AppDelegate`
    ///
    ///
    func gotoHome(redirection: Redirections = .home) {
        UserManager.shared.fetchUserInfo() // --- Update user
        CartEntity.fetchAndUpdateCart()// --- Update Cart
        
        let tabBarController = UIStoryboard.getVC(from: .Main, "TabBarController") as! UITabBarController
        self.tabBar = tabBarController.tabBar
        tabBar?.backgroundImage = UIImage()
        tabBar?.shadowImage = UIImage()
        
        tabBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar?.layer.shadowRadius = 10
        tabBar?.layer.shadowColor = UIColor.black.cgColor
        tabBar?.layer.shadowOpacity = 0.3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UIApplication.shared.applicationIconBadgeNumber > 0 {
                self.addOrRemoveNotificationBadge()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addOrRemoveNotificationBadge), name: .notificationUpdated, object: nil)
        
        let navigation = CustomNavigation.shared.makeNavigation(with: tabBarController)
        AppDelegate.shared.window?.rootViewController = navigation
        AppDelegate.shared.window?.makeKeyAndVisible()
        
        switch redirection {
        case .home:
            tabBarController.selectedIndex = 0
        case .search:
            tabBarController.selectedIndex = 1
        case .notification:
            tabBarController.selectedIndex = 2
        case .account(let orderId):
            tabBarController.selectedIndex = 3
            if orderId != "" {
                self.goToOrderListing(with: [.PENDING, .ACCEPTED, .SHIPPED, .CANCELLED_BY_VENDOR, .CANCELED, .REJECTED], type: .Order, navigation: navigation)
            }
        case .menu:
            tabBarController.selectedIndex = 4
        }
    }
    
    //MARK: Helpers
    @objc func addOrRemoveNotificationBadge() {
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            tabBar?.addBadge(index: 2)
        } else {
            tabBar?.removeBadge(index: 2)
        }
    }
    
    //MARK: Navigations
    func showCart(){
        let vc = UIStoryboard.getVC(from: .ShoppingCart, ShoppingCartViewController.className) as! ShoppingCartViewController

        let navigation = CustomNavigation.shared.makeNavigation(with: vc)
        navigation.modalPresentationStyle = .fullScreen
        self.presentOnRoot(navigation, animated: true, completion: nil)
    }
    
    func goToLogin(redirectToHome: Bool = false){
        let vc = UIStoryboard.getVC(from: .Auth, SignInViewController.className) as! SignInViewController
        vc.redirectToHome = redirectToHome
        let navigation = CustomNavigation.shared.makeNavigation(with: vc)
        self.presentOnRoot(navigation, animated: true, completion: nil)
    }
    
    func goToOrderListing(with filters: [OrderStatus], type orderType: OrderType, navigation: UINavigationController) {
        let vc = UIStoryboard.getVC(from: .Orders, OrderListingViewController.className) as! OrderListingViewController
        vc.filters = filters
        vc.orderType = orderType
        navigation.pushViewController(vc, animated: true)
        
    }
    
    
    func presentOnRoot(_ viewController: UIViewController, animated: Bool, completion: (()->Void)?) {
        
        let appDelegate = AppDelegate.shared
        let rootVC = appDelegate.window?.rootViewController
        if var presented = rootVC?.presentedViewController {
            while presented.presentedViewController != nil {
                presented = presented.presentedViewController!
            }
            presented.present(viewController, animated: animated, completion: completion)
        }
        else {
            rootVC?.present(viewController, animated: animated, completion: completion)
        }
    }
    
}

//MARK: UITabBar
extension UITabBar {
    func addBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = "\(UIApplication.shared.applicationIconBadgeNumber)"
            tabItem.badgeColor = .febysRed()
        }
    }
    func removeBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
    }
    
 }

enum Redirections {
    case home
    case search
    case notification
    case account(orderId: String)
    case menu
}

