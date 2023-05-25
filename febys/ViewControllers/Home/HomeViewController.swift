//
//  HomeViewController.swift
//  febys
//
//  Created by Waseem Nasir on 07/07/2021.
//

import UIKit
//import ZendeskCoreSDK
//import SDKConfigurations
//import MessagingAPI
//import SupportSDK
//import MessagingSDK
//import AnswerBotSDK
//import ChatSDK
//import ChatProvidersSDK

class HomeViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var viewWishlistButton: FebysButton!
    @IBOutlet weak var cartCountLabel: FebysLabel!
    @IBOutlet var baseView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var chatButton: FebysButton!

    //MARK: PROPERTIES
    var isFollowUpdated = false
    var rippleView: SMRippleView?
    var seasonalOfferName: String?
    var homeData: [HomeCells] = []
    var banners: [HomeBanner]?
    var uniqueCategories: [UniqueCategory]?
    var todayDeals: ProductResponse?
    var trendingProducts: ProductResponse?
    var storesYouFollow: ProductResponse?
    var offers: [Offer]?
    var sameDayDelivery: ProductResponse?
    var under100: ProductResponse?
    var editorsPick: ProductResponse?
    var featuredCategories: [FeaturedCategoryResponse]?
    var featuredStores = Array(repeating: FeaturedStores(), count: 2)

    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRippleView()
        initNotificationObservers()
        registerCells()
        fetchData()
        updateWishlist()
        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        
        if isFollowUpdated {
            self.isFollowUpdated = false
            self.fetchStoresYouFollow()
        }
        
        self.tableView.reloadData()
    }
    
    func registerCells() {
        tableView.register(UniqueCatergoryTableViewCell.className)
        tableView.register(ProductsTableViewCell.className)
        tableView.register(BannerTableViewCell.className)
        tableView.register(SameDayDeliveryViewCell.className)
        tableView.register(StoreYouFollow.className)
        tableView.register(SeasonalOfferTableViewCell.className)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    }
    
    //MARK: IBAction
    func setupButtonActions() {
        viewWishlistButton.didTap = {
            self.goToWishlist()
        }
        
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
        
        chatButton.didTap = {
            self.presentZendeskChat()
        }
    }
    
    //MARK: Helpers
    func configureRippleView() {
        rippleView = SMRippleView(frame: self.baseView.bounds, rippleColor: .febysRed(), rippleThickness: 9 , rippleTimer: 0.7, fillColor: .febysRed(), animationDuration: 3, parentFrame: self.parentView.frame)
        self.baseView.addSubview(rippleView!)

    }
    
    func initNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: .cartUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(followUpdated), name: .followUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWishlist), name: .wishlistUpdated, object: nil)
    }
    
    @objc func updateCartCount(){
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        cartCountLabel.animate(duration: 0.3)
    }
    
    @objc func updateWishlist(){
        (WishlistManager.shared.getWishlistItemCount() < 1)
        ? (self.viewWishlistButton.isSelected = true)
        : (self.viewWishlistButton.isSelected = false)
    }
    
    @objc func followUpdated(){
        self.isFollowUpdated = true
    }
    
    
    func prepareData() {
        homeData.removeAll()
        if let uniqueCategories = uniqueCategories{
            if !uniqueCategories.isEmpty {
                homeData.append(.uniqueCatergories(uniqueCategories))
            }
        }
        
        if let banners = banners{
            if !banners.isEmpty {
                homeData.append(.banner(banners))
            }
        }
        
        if let products = todayDeals?.listing?.products{
            if !products.isEmpty {
                homeData.append(.todayDeals(products))
            }
        }
        
        if let featuredCategories = featuredCategories{
            if !featuredCategories.isEmpty {
                homeData.append(.featuredCategories(featuredCategories))
            }
        }
        
//        if !featuredStores.isEmpty {
//            homeData.append(.featuredStores(featuredStores))
//        }
    
        if let offers = offers{
            if !offers.isEmpty {
                homeData.append(.seasonalOffers(offers))
            }
        }
        
        if let trendingProducts = trendingProducts?.listing?.products {
            if !trendingProducts.isEmpty {
                homeData.append(.trending(trendingProducts))
            }
        }
        
        if let products = storesYouFollow?.listing?.products{
            if !products.isEmpty {
                homeData.append(.storesYouFollow(products))
            }
        }
        
        if let products = sameDayDelivery?.listing?.products{
            if !products.isEmpty {
                homeData.append(.sameDayDelivery(products))
            }
        }
                
        if let products = under100?.listing?.products{
            if !products.isEmpty {
                homeData.append(.under100(products))
            }
        }
        
        if let products = editorsPick?.listing?.products{
            if !products.isEmpty {
                homeData.append(.editorsPick(products))
            }
        }
        
        tableView.reloadData()
    }
    
    //MARK: Navigation
    func goToProductList(title: String, filterType: FilterType, _ repo: ProductRepository){
        let vc = UIStoryboard.getVC(from: .Product, ProductListViewController.className) as! ProductListViewController
        vc.titleName = title
        vc.filterType = filterType
        vc.repo = repo
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductDetail(_ productId: String, skuId: String){
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = productId
        vc.preferredSkuId = skuId
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToWishlist() {
        if User.fetch() != nil {
            let vc = UIStoryboard.getVC(from: .WishList, WishListViewController.className) as! WishListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            RedirectionManager.shared.goToLogin()
        }
    }
    
    
    func presentZendeskChat() {
        if User.fetch() != nil {
            do {
                let vc = try ZendeskManager.shared.buildMessagingViewController()
                let navigation = UINavigationController(rootViewController: vc)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    navigation.navigationItem.title = "Hello"
                    navigation.navigationBar.barTintColor = .yellow
                }
            
                
//                navigation.modalPresentationStyle = .fullScreen
                present(navigation, animated: true)
            } catch {
                print(error)
            }
        } else {
            RedirectionManager.shared.goToLogin()
        }
    }
    
    //MARK: API CALLS
    func fetchData(){
        fetchUniqueCategories()
        fetchBanners()
        fetchTodayDeals()
        fetchFeaturedCategories()
//        fetchFeaturedVendors()
//        fetchFeaturedCelebrities()
        fetchStoresYouFollow()
        fetchSeasonalOffers()
        fetchTrendingProducts()
        fetchSameDayDelivery()
        fetchUnderHundered()
        fetchEditorsPick()
    }
    
    //MARK: UniqueCategories
    func fetchUniqueCategories(){
        Loader.show()
        CategoryService.shared.uniqueCategory{ response in
            Loader.dismiss()
            switch response{
            case .success(let categories):
                self.uniqueCategories = categories
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: Banners
    func fetchBanners(){
        Loader.show()
        OfferService.shared.homeBanner { response in
            Loader.dismiss()
            switch response{
            case .success(let banners):
                self.banners = banners.filter({$0.type == "headerImages"})
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: SeasonalOffers
    func fetchSeasonalOffers(){
        Loader.show()
        OfferService.shared.seasonalOffers { response in
            Loader.dismiss()
            switch response{
            case .success(let offersResponse):
                var offers = [Offer]()
                _ = offersResponse.compactMap({ offer in
                    offers.append(contentsOf: offer.offer ?? [])
                })
                self.seasonalOfferName = offersResponse.first?.name
                self.offers = offers
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: TodayDeals
    func fetchTodayDeals(){
        Loader.show()
        ProductService.shared.todayDeals { response in
            Loader.dismiss()
            switch response{
            case .success(let deals):
                self.todayDeals = deals
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: TrendingProducts
    func fetchTrendingProducts(){
        let trendsOnSale = [ParameterKeys.variants_trendsOnSale: true]
        let statsValue = [ParameterKeys.variants_statsSales_value: ParameterKeys.desc]

        let bodyParams = [ParameterKeys.filters: trendsOnSale,
                          ParameterKeys.sorter: statsValue] as [String : Any]
        
        Loader.show()
        ProductService.shared.allProducts(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let products):
                self.trendingProducts = products
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: SameDayDelivery
    func fetchSameDayDelivery(){
        let sameDayDelivery = [ParameterKeys.same_day_delivery: true]
        let bodyParams = [ParameterKeys.filters: sameDayDelivery] as [String:Any]
        
        Loader.show()
        ProductService.shared.allProducts(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let products):
                self.sameDayDelivery = products
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: UnderHundered
    func fetchUnderHundered(){
        Loader.show()
        ProductService.shared.under100 { response in
            Loader.dismiss()
            switch response{
            case .success(let products):
                self.under100 = products
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: Editors Pick
    func fetchEditorsPick(){
        let editorsPick = [ParameterKeys.editor_picked: true]
        let bodyParams = [ParameterKeys.filters: editorsPick] as [String : Any]
        
        Loader.show()
        ProductService.shared.allProducts(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let products):
                self.editorsPick = products
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: FeaturedCategories
    func fetchFeaturedCategories(){
        Loader.show()
        CategoryService.shared.featuredCategories { response in
            Loader.dismiss()
            switch response{
            case .success(let featured):
                self.featuredCategories = featured
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: FeaturedStores
    func fetchFeaturedVendors(){
        let featured = [ParameterKeys.featured: true]
        let bodyParams = [ParameterKeys.filters: featured] as [String : Any]
        
        Loader.show()
        VendorService.shared.getVendorListing(isRecommended: false, body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let featured):
                let featuredVendors = FeaturedStores()
                featuredVendors.name = "Vendors"
                featuredVendors.vendors = featured.listing?.vendors
                self.featuredStores.insert(featuredVendors, at: 0)
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchFeaturedCelebrities(){
        let featured = [ParameterKeys.featured: true]
        let bodyParams = [ParameterKeys.filters: featured] as [String : Any]
        
        Loader.show()
        CelebrityService.shared.getCelebrityListing(isRecommended: false, body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let featured):
                let featuredVendors = FeaturedStores()
                featuredVendors.name = "Celebrities"
                featuredVendors.vendors = featured.listing?.vendors
                self.featuredStores.insert(featuredVendors, at: 1)
                self.prepareData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: StoresYouFollow
    func fetchStoresYouFollow(){
        if User.fetch() != nil {
            Loader.show()
            ProductService.shared.storesYouFollowHome { response in
                Loader.dismiss()
                switch response{
                case .success(let products):
                    self.storesYouFollow = products
                    self.prepareData()
                    break
                case .failure(let error):
                    self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                }
            }
        }
    }
    
    func goToLogin(){
        let vc = UIStoryboard.getVC(from: .Product, SignInViewController.className) as! SignInViewController
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch homeData[indexPath.row] {
        case .uniqueCatergories(let categories):
            let cell = tableView.dequeueReusableCell(withIdentifier: UniqueCatergoryTableViewCell.className, for: indexPath) as! UniqueCatergoryTableViewCell
            cell.configure(categories: categories)
            
            cell.didSelectCategory = { [weak self] category in
                self?.goToProductList(title: category.name ?? "", filterType: .category(id: category.categoryId ?? 0), CategoryProductsRepository(category.categoryId ?? 0))
            }
            
            return cell
            
        case .banner(let banners):
            let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.className, for: indexPath) as! BannerTableViewCell
            cell.configure(banners)
            
            cell.didSelectBanner = { [weak self] banner in
                self?.goToProductList(title: banner.name ?? "", filterType: .category(id: banner.category_id ?? 0), CategoryProductsRepository(banner.category_id ?? 0))
            }
//
            return cell
            
        case .todayDeals(let products):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(for: .todayDeals(products), products: products)
            
            cell.shopNowButtonTapped = { [weak self] in
                self?.goToProductList(title: "Today's Deals", filterType: .todayDeal, TodayDealsRepository())
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            
            return cell
            
        case .featuredCategories(let featuredCategories):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(forCategories: featuredCategories)
            cell.shopNowButtonTapped = { [weak self] in
                if let selectedCategory = cell.featuredCategories?.first(where: {$0.isSelected}){
                    self?.goToProductList(title: selectedCategory.name ?? "", filterType: .category(id: selectedCategory.id ?? 0), CategoryProductsRepository(selectedCategory.id ?? 0))
                }
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            
            return cell
            
        case .featuredStores(let featuredStores):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(forVendors: featuredStores)
            cell.contentViewTopConstraint.constant = 35
            cell.contentViewBottomConstraint.constant = 35
            cell.shopNowButtonTapped = { [weak self] in
                if let selectedCategory = cell.featuredCategories?.first(where: {$0.isSelected}){
                    self?.goToProductList(title: selectedCategory.name ?? "", filterType: .category(id: selectedCategory.id ?? 0), CategoryProductsRepository(selectedCategory.id ?? 0))
                }
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            
            return cell
            
        case .seasonalOffers(let offers):
            let cell = tableView.dequeueReusableCell(withIdentifier: SeasonalOfferTableViewCell.className, for: indexPath) as! SeasonalOfferTableViewCell
            cell.configure(offers)
            cell.didSelectOffer = { [weak self] offer in
                self?.goToProductList(title: self?.seasonalOfferName ?? "", filterType: .category(id: offer.category_id ?? 0), CategoryProductsRepository(offer.category_id ?? 0))
            }
            
            return cell
            
        case .trending(let products):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(for: .trending(products), products: products)
            
            cell.shopNowButtonTapped = { [weak self] in
                self?.goToProductList(title: "Trending Products", filterType: .none, TrendingProductsRepository())
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            
            return cell
            
        case .under100(let products):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(for: .under100(products), products: products)
            
            cell.shopNowButtonTapped = { [weak self] in
                self?.goToProductList(title: "Under GHS 100 Items", filterType: .under100, Under100ProductsRepository())
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            return cell
            
        case .sameDayDelivery(let products):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(for: .sameDayDelivery(products), products: products)
            
            cell.shopNowButtonTapped = { [weak self] in
                self?.goToProductList(title: "Same Day Delivery", filterType: .under100, SameDayRepository())
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            return cell
            
        case .editorsPick(let products):
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.className, for: indexPath) as! ProductsTableViewCell
            cell.configure(for: .editorsPick(products), products: products)
            
            cell.shopNowButtonTapped = { [weak self] in
                self?.goToProductList(title: "Editor's Pick", filterType: .none, EditorsPickRepository())
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            return cell
            
        case .storesYouFollow(let products):
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreYouFollow.className, for: indexPath) as! StoreYouFollow
            cell.configure(products: products)
            
            cell.shopNowButtonTapped = { [weak self] in
                self?.goToProductList(title: "Stores You Follow", filterType: .none, StoresYouFollowRepository())
            }
            
            cell.didSelectProduct = { [weak self] productId, skuId in
                self?.goToProductDetail(productId, skuId: skuId)
            }
            return cell
            
//        case .sameDayDelivery:
//            let cell = tableView.dequeueReusableCell(withIdentifier: SameDayDeliveryViewCell.className, for: indexPath) as! SameDayDeliveryViewCell
//            cell.configure()
//            return cell
//
        }
    }
}

enum HomeCells {
    case uniqueCatergories([UniqueCategory])
    case banner([HomeBanner])
    case todayDeals([Product])
    case featuredCategories([FeaturedCategoryResponse])
    case featuredStores([FeaturedStores])
    case seasonalOffers([Offer])
    case trending([Product])
    case storesYouFollow([Product])
    case sameDayDelivery([Product])
    case under100([Product])
    case editorsPick([Product])
}
