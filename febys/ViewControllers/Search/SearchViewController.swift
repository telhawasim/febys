//
//  SearchViewController.swift
//  febys
//
//  Created by Waseem Nasir on 11/07/2021.
//

import UIKit
import XLPagerTabStrip

class SearchViewController: ButtonBarPagerTabStripViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var cartCountLabel: FebysLabel!
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var searchProductButton: FebysButton!
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        self.configureXLTabView()
        super.viewDidLoad()
        self.setupActionButtons()

        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: .cartUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
    }
    
    //MARK: IBACTIONS
    func setupActionButtons() {
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
        
        searchProductButton.didTap = { [weak self] in
            self?.goToSuggestionList()
        }
    }
    
    //MARK: HELPERS
    @objc func updateCartCount(){
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        cartCountLabel.animate(duration: 0.3)

    }
    
    func configureXLTabView() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .black
        settings.style.buttonBarItemFont = .helvetica(type: .bold, size: 12)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarHeight = 10.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            oldCell?.label.font = .helvetica(type: .medium, size: 12)
            newCell?.label.textColor = .black
            newCell?.label.font = .helvetica(type: .bold, size: 12)
        }
    }
    
    //MARK: NAVIGATION
    
    func goToSuggestionList() {
        let vc = UIStoryboard.getVC(from: .Main, SuggestionViewController.className) as! SuggestionViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: -  PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = UIStoryboard.getVC(from: .Main, CategoryListViewController.className) as! CategoryListViewController
        child_1.itemInfo = IndicatorInfo(title: Constants.categories)
        
        let child_2 = UIStoryboard.getVC(from: .Main, StoresViewController.className) as! StoresViewController
        child_2.itemInfo = IndicatorInfo(title: Constants.stores)
        
        let child_3 = UIStoryboard.getVC(from: .VendorStore, VendorListViewController.className) as! VendorListViewController
        child_3.isCelebrityListing = false
        child_3.itemInfo = IndicatorInfo(title: Constants.vendorStores)
        
        let child_4 = UIStoryboard.getVC(from: .VendorStore, VendorListViewController.className) as! VendorListViewController
        child_4.isCelebrityListing = true
        child_4.itemInfo = IndicatorInfo(title: Constants.celebrityMarket)
        
        let child_5 = UIStoryboard.getVC(from: .Main, CategoryListViewController.className) as! CategoryListViewController
        child_5.itemInfo = IndicatorInfo(title: Constants.promotion)
        
        return [child_1, child_2,child_3,child_4]
    }
}

