//
//  ProductsTableViewCell.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import UIKit

class FeaturedStores {
    var name : String?
    var vendors : [Vendor]?
    var isSelected: Bool = false
}

class ProductsTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var shopNowButtonView: UIView!
    @IBOutlet weak var shopNowButton: FebysButton!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var detailLabel: FebysLabel!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!

    //MARK: Properties
    var showVendorsData = false
    var featuredCategories: [FeaturedCategoryResponse]?
    var featuredStores: [FeaturedStores]?
    var products: [Product]?
    var vendors: [Vendor]?
    var didSelectProduct: ((String, String)->())?
    var didSelectVendor: ((String)->())?
    var shopNowButtonTapped: (()->())?
    
    var isAlreadyUpdated: Bool = false
    var hasPromotion: Bool = false {didSet{updateCollectionViewHeight()}}

    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        categoriesCollectionView.register(CategoryCell.className)
        collectionView.register(ProductCell.className)
        collectionView.register(VendorsCell.className)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20,  bottom: 0, right: 20)
    }
    
    //MARK: Helpers
    private func updateCollectionViewHeight() {
        if !isAlreadyUpdated {
            self.isAlreadyUpdated = true
            self.collectionViewHeight.constant = 330
        }
    }
    
    private func configure(showCategories: Bool = false){
        self.categoriesCollectionView.isHidden = showCategories ? false : true
        self.shopNowButtonView.isHidden = showVendorsData ? true : false
        shopNowButton.didTap = { [weak self] in
            self?.shopNowButtonTapped?()
        }
    }
    
    func configure(for productType: HomeCells, products: [Product]?){
        self.contentView.backgroundColor = .white
        showVendorsData = false
        configure(showCategories: false)

        switch productType {
        case .todayDeals:
            titleLabel.text = "Today's Deals"
            detailLabel.text = "Discover new deal’s, just for you"
            
        case .under100:
            titleLabel.text = "Under ₵100 Items"
            detailLabel.text = "Discover new deal’s, just for you"
            
        case .trending:
            titleLabel.text = "Trending Products"
            detailLabel.text = "Discover the top selling products"
           
        case .sameDayDelivery(_):
            titleLabel.text = "Same Day Delivery"
            detailLabel.text = "Explore things that you want on a same day "
            
        case .editorsPick(_):
            titleLabel.text = "Editor's Pick"
            detailLabel.text = "We think you’ll love these"
            
        default:
            titleLabel.text = "Featured Categories"
            detailLabel.text = "We think you’ll love these"
        }
        
        self.products = products
        
        _ = products?.compactMap({ product in
            let variants = product.variants
            let variant = variants?.first(where: {$0.isDefault == true}) ?? variants?.first
            
            if let hasPromotion = variant?.hasPromotion, hasPromotion == true {
                self.hasPromotion = hasPromotion
            }
        })
        
        self.collectionView.reloadData()
    }
    
    func configure(forCategories featuredCategories: [FeaturedCategoryResponse]?){
        self.contentView.backgroundColor = .white
        showVendorsData = false
        configure(showCategories: true)
        
        titleLabel.text = "Featured Categories"
        detailLabel.text = "We think you’ll love these"
        
        self.featuredCategories = featuredCategories
        if let first = self.featuredCategories?.first{
            selectCategory(category: first)
        }
    }
    
    func configure(forVendors featuredStores: [FeaturedStores]?){
        self.contentView.backgroundColor = .febysLightGray()
        collectionViewHeight.constant = 160
        
        showVendorsData = true
        configure(showCategories: true)
        
        titleLabel.text = "Featured Stores"
        detailLabel.text = "We think you’ll love these"
        
        self.featuredStores = featuredStores
        if let first = self.featuredStores?.first{
            selectStore(store: first)
        }
    }
    
    private func selectCategory(category: FeaturedCategoryResponse){
        _ = self.featuredCategories?.compactMap({$0.isSelected = false})
        
        category.isSelected = true
        self.categoriesCollectionView.reloadData()
        self.products = category.products

        _ = category.products?.compactMap({ product in
            let variants = product.variants
            let variant = variants?.first(where: {$0.isDefault == true}) ?? variants?.first
            
            if let hasPromotion = variant?.hasPromotion, hasPromotion == true {
                self.hasPromotion = hasPromotion
            }
        })
        
        if let products = products, !products.isEmpty,
           (self.collectionView.numberOfItems(inSection: 0) > 0) {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
        self.collectionView.reloadData()
    }
    
    private func selectStore(store: FeaturedStores){
        _ = self.featuredStores?.compactMap({$0.isSelected = false})
        store.isSelected = true
        self.categoriesCollectionView.reloadData()
        self.vendors = store.vendors
        
        if let vendors = self.vendors, !vendors.isEmpty,
           (self.collectionView.numberOfItems(inSection: 0) > 0) {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
        self.collectionView.reloadData()        
    }
    
    func calculateDynamicWidth(of string: String, padding: CGFloat ) -> CGFloat {
        if string.count > 1 {
            return string.widthOfString(usingFont: UIFont(name: Helvetica.medium.rawValue, size: 12)!)
            + padding
        } else {
            return 0
        }
    }
}

//MARK: COLLECTION VIEW DELEGATES
extension ProductsTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.collectionView:
            if showVendorsData {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VendorsCell.className, for: indexPath) as! VendorsCell
                let item = vendors?[indexPath.row]
                cell.configure(vendor: item)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.className, for: indexPath) as! ProductCell
                let item = products?[indexPath.row]
                cell.configure(product: item, isLarge: false)
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.className, for: indexPath) as! CategoryCell
           
            if showVendorsData {
                let item = featuredStores?[indexPath.row]
                cell.configureWith(title: item?.name ?? "", isSelected: item?.isSelected ?? false, inverted: true)
            } else {
                cell.configure(item: featuredCategories?[indexPath.row])
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return showVendorsData
            ? (vendors?.count ?? 0)
            : (products?.count ?? 0)
        } else {
            return showVendorsData
            ? (featuredStores?.count ?? 0)
            : (featuredCategories?.count ?? 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.categoriesCollectionView:
            if showVendorsData {
                if let item = featuredStores?[indexPath.row] {
                    selectStore(store: item)
                }
            } else {
                if let item = featuredCategories?[indexPath.row] {
                    selectCategory(category: item)
                }
            }
            
        default:
            if showVendorsData {
                if let selectedVendor = vendors?[indexPath.row],
                   let vendorId = selectedVendor.id {
                    didSelectVendor?(vendorId)
                }
            } else {
                if let selectedProduct = products?[indexPath.row],
                   let productId = selectedProduct.id,
                   let variant = selectedProduct.variants?.first(where: {$0.isDefault == true}) ?? selectedProduct.variants?.first {
                    didSelectProduct?(productId, variant.skuId ?? "")
                }
            }
        }
    }
}

//MARK: CollectionView Method Flow Layout
extension ProductsTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch collectionView {
        case self.collectionView:
            let height = collectionView.frame.height
            let width = showVendorsData ? collectionView.frame.height : 235.0
            return CGSize(width: width, height: height)

        default:
            let nameString = showVendorsData
            ? featuredStores?[indexPath.row].name ?? ""
            : featuredCategories?[indexPath.row].name ?? ""
            
            let height = self.categoriesCollectionView.frame.height
            let width = calculateDynamicWidth(of: nameString, padding: 32)
            return CGSize(width: width, height: height)
        }
    }
}


