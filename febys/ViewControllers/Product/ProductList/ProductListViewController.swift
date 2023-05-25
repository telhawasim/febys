//
//  ProductListViewController.swift
//  febys
//
//  Created by Ab Saqib on 13/07/2021.
//

import UIKit

class ProductListViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var cartCountLabel: FebysLabel!
    @IBOutlet weak var vendorRoleLabel: FebysLabel!
    @IBOutlet weak var storeDetailButton: FebysButton!
    @IBOutlet weak var storeNameLabel: FebysLabel!
    @IBOutlet weak var itemCountLable1: FebysLabel!
    @IBOutlet weak var itemCountLable2: FebysLabel!
    @IBOutlet weak var vendorDetailStackView: UIView!
    @IBOutlet weak var productDetailStackView: UIStackView!
    
    //MARK: PROPERTIES
    private let numberOfItemPerRow = 2
    private let screenWidth = UIScreen.main.bounds.width
    private let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let minimumInteritemSpacing = CGFloat(0)
    private let minimumLineSpacing = CGFloat(0)
    
    var selectedFilters: [String:[String:[Any]]] = [:]
    var selectedVendors: [String] = []
    var selectedCategories: [Int] = []
    var filterResponse: FiltersResponse?
    var repo: ProductRepository?
    private var productResponse: ProductResponse?
    
    var showVendorDetail = false
    var filterType: FilterType?
    var titleName = ""
    
    var vendorId = ""
    var vendorRole = ""
    var storeName = ""
    var isLoading = true
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleName
        
        setUpCollectionView()
        handleResponse()
        fetchFilters(of: filterType ?? .none)
        configureVendorDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: .cartUpdated, object: nil)
        
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
        
        storeDetailButton.didTap = { [weak self] in
            self?.goToVendorDetail(of: self?.vendorId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        updateCartCount()
    }
    
    
    //MARK: HELPERS
    @objc func updateCartCount(){
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        cartCountLabel.animate(duration: 0.3)
        
    }
    
    func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20,  bottom: 0, right: 20)
        
        collectionView.register(ProductItemCell.className)
        filterCollectionView.register(CategoryCell.className)
        collectionView.register(EmptyViewsCollectionViewCell.className)
        
    }
    
    func configureVendorDetail() {
        self.vendorRoleLabel.text = vendorRole
        self.storeNameLabel.text = storeName
        self.showVendorDetail ? didHideVendorDetail(false) : didHideVendorDetail(true)
    }
    
    func didHideFilters(_ isHidden: Bool) {
        isHidden
        ? (self.filtersView.isHidden = true)
        : (self.filtersView.isHidden = false)
    }
    
    func didHideVendorDetail(_ isHidden: Bool) {
        if isHidden {
            self.vendorDetailStackView.isHidden = true
            self.productDetailStackView.isHidden = false
        } else {
            self.vendorDetailStackView.isHidden = false
            self.productDetailStackView.isHidden = true
        }
    }
    
    private func selectVendor(id: String) {
        if !(filterResponse?.filters?.vendors?.vendors?.count == 0) {
            if selectedVendors.contains(where: {$0 == id}) {
                selectedVendors.removeAll(where: {$0 == id})
            } else {
                selectedVendors.append(id)
            }
        }
        self.filterCollectionView.reloadData()
    }
    
    private func selectCategory(id: Int) {
        if !(filterResponse?.filters?.availableCategories?.count == 0) {
            if selectedCategories.contains(where: {$0 == id}) {
                selectedCategories.removeAll(where: {$0 == id})
            } else {
                selectedCategories.append(id)
            }
        }
        self.filterCollectionView.reloadData()
    }
    
    func calculateDynamicWidth(of string: String, padding: CGFloat ) -> CGFloat {
        if string.count > 1 {
            return string.widthOfString(usingFont: UIFont(name: Helvetica.medium.rawValue, size: 12)!)
            + padding
        } else {
            return 0
        }
    }
    
    //MARK: NAVIGATION
    func goToProductDetail(of productId: String, skuId: String) {
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = productId
        vc.preferredSkuId = skuId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToVendorDetail(of vendorId: String?) {
        let vc = UIStoryboard.getVC(from: .VendorStore, VendorDetailViewController.className) as! VendorDetailViewController
        vc.vendorId = vendorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotToFilter() {
        let vc = UIStoryboard.getVC(from: .Filters, FiltersViewController.className) as! FiltersViewController
        vc.filterDelegate = self
        vc.showAttributes = false
        vc.filters = self.filterResponse?.filters
        vc.selectedFilters = self.selectedFilters
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: FILTERS DATA
    func preparePriceRangeFrom(_ filters:[String:[String:[Any]]]) -> [String:Any]? {
        let key = ParameterKeys.variants_price_value
        var priceRange = [String:Any]()
        var range: [String:Any]? = [:]
        if let min = filters[key]?[ParameterKeys.minimum]?.first {
            if (min as? Double) != 0.0 { range?[ParameterKeys.greaterThen] = min }
        }
        if let max = filters[key]?[ParameterKeys.maximum]?.first {
            if (max as? Double) != 0.0 { range?[ParameterKeys.lessThen] = max }
        }
        
        if let range = range {
            if !range.isEmpty {
                priceRange[key] = range
            }
        }
        return priceRange
    }
    
    func prepareSorterFrom(_ filters:[String:[String:[Any]]]) -> [String:Any]? {
        let key = ParameterKeys.sorter
        var sorter: [String:Any]? = [:]
        if let value = filters[key]?[ParameterKeys.variants_price_value]?.first {
            sorter?[ParameterKeys.variants_price_value] = value
        }
        return sorter
    }
    
    func prepareAttributesFrom(_ filters:[String:[String:[Any]]]) -> [String:Any]? {
        let parentKey = ParameterKeys.variants_attributes_value
        var attributes: [Any] = []
        filters[parentKey]?.forEach { key, attribute in
            filters[parentKey]?[key]?.forEach { values in
                attributes.append(values)
            }
        }
        var varients: [String:Any]? = [:]
        if !attributes.isEmpty { varients?[ParameterKeys.dollarIN] = attributes }
        return varients
    }
    
    func prepareCategoriesFrom(_ selectedCategories: [Any]) -> [String:[Any]]? {
        var categories: [String:[Any]]? = [:]
        if !selectedCategories.isEmpty { categories?[ParameterKeys.dollarIN] = selectedCategories }
        return categories
    }
    
    
    func prepareVendorsFrom(_ selectedVendors: [Any]) -> [String:[Any]]? {
        var vendors: [String:[Any]]? = [:]
        if !selectedVendors.isEmpty { vendors?[ParameterKeys.dollarIN] = selectedVendors }
        return vendors
    }
    
    
    func prepareFilters(_ filters: [String:[String:[Any]]]) -> [String:[String:Any]]? {
        var body:[String:[String:Any]] = [:]
        
        var filter:[String: Any] = [:]
        
        if let price = self.preparePriceRangeFrom(filters) {
            if !price.isEmpty { filter[ParameterKeys.dollarOR] = [price] }
        }
        if let attribute = self.prepareAttributesFrom(filters) {
            if !attribute.isEmpty { filter[ParameterKeys.variants_attributes_value] = attribute }
        }
        if let categories = self.prepareCategoriesFrom(selectedCategories) {
            if !categories.isEmpty { filter[ParameterKeys.category_id] = categories }
        }
        if let vendors = self.prepareVendorsFrom(selectedVendors) {
            if !vendors.isEmpty { filter[ParameterKeys.vendor_id] = vendors }
        }
        if let sorter = self.prepareSorterFrom(filters) {
            if !sorter.isEmpty { body[ParameterKeys.sorter] = sorter }
        }
        
        body[ParameterKeys.filters] = filter
        return body
    }
    
    //MARK: API CALLS
    func fetchProductResponse(with filters: [String:[String:Any]]) {
        self.productResponse = nil
        repo?.pageNo = 1
        repo?.filterParams = filters
        repo?.fetchProducts()
    }
    
    func handleResponse(){
        repo?.response = { response in
            switch response{
            case .success(let productResponse):
                let count = productResponse.listing?.totalRows ?? 0
                let item = count == 1 ? "Item" : "Items"
                self.itemCountLable1.text = "\(count) \(item)"
                self.itemCountLable2.text = "\(count) \(item)"
                if self.productResponse == nil{
                    self.productResponse = productResponse
                } else {
                    self.productResponse?.listing?.products?.append(contentsOf: productResponse.listing?.products ?? [])
                }
                self.isLoading = false
                self.collectionView.reloadData()
            case .failure(let error):
                self.isLoading = false
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchFilters(of type: FilterType) {
        switch type {
        case .category(let id):
            self.didHideFilters(false)
            self.fetchCategoryFiltersBy(id: id)
        case .todayDeal:
            self.didHideFilters(false)
            self.fetchTodayDealFilters()
        case .under100:
            self.didHideFilters(false)
            self.fetchUnder100Filters()
        case .searchProduct(let searchStr):
            self.didHideFilters(false)
            self.fetchSearchProductFilters(searchStr)
        case .vendorProduct(let vendorId):
            self.showVendorDetail = true
            self.vendorId = vendorId
            self.didHideFilters(false)
            self.fetchVendorProductFiltersBy(id: vendorId)
        case .none:
            self.didHideFilters(true)
        }
    }
    
    func fetchCategoryFiltersBy(id: Int) {
        Loader.show()
        FilterService.shared.fetchCategoryFiltersBy(id: id) { response in
            Loader.dismiss()
            switch response {
            case .success(let filterResponse):
                self.filterResponse = filterResponse
                self.isLoading = false
                self.filterCollectionView.reloadData()
                break
            case .failure(_):
                self.isLoading = false
                break
            }
        }
    }
    
    func fetchTodayDealFilters() {
        Loader.show()
        FilterService.shared.fetchTodayDealsFilters { response in
            Loader.dismiss()
            switch response {
            case .success(let filterResponse):
                self.filterResponse = filterResponse
                self.isLoading = false
                self.filterCollectionView.reloadData()
                break
            case .failure(_):
                self.isLoading = false
                break
            }
        }
    }
    
    func fetchUnder100Filters() {
        Loader.show()
        FilterService.shared.fetchUnder100Filters { response in
            Loader.dismiss()
            switch response {
            case .success(let filterResponse):
                self.filterResponse = filterResponse
                self.isLoading = false
                self.filterCollectionView.reloadData()
                break
            case .failure(_):
                self.isLoading = false
                break
            }
        }
    }
    
    func fetchSearchProductFilters(_ searchStr: String) {
        let params = [ParameterKeys.searchStr: searchStr]
        Loader.show()
        FilterService.shared.fetchSearchProductFilters(params: params) { response in
            Loader.dismiss()
            switch response {
            case .success(let filterResponse):
                self.filterResponse = filterResponse
                self.isLoading = false
                self.filterCollectionView.reloadData()
                break
            case .failure(_):
                self.isLoading = false
                break
            }
        }
    }
    
    func fetchVendorProductFiltersBy(id: String) {
        Loader.show()
        FilterService.shared.fetchVendorProductFiltersBy(id: id) { response in
            Loader.dismiss()
            switch response {
            case .success(let filterResponse):
                self.filterResponse = filterResponse
                self.isLoading = false
                self.filterCollectionView.reloadData()
                break
            case .failure(_):
                self.isLoading = false
                break
            }
        }
    }
}

//MARK: FilterDelegate
extension ProductListViewController : FilterDelegate {
    func didApplyFilters(filters: [String:[String:[Any]]]) {
        self.selectedFilters = filters
        self.fetchProductResponse(with: self.prepareFilters(filters) ?? [:])
    }
}

//MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension ProductListViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isLoading {
            return 0
        } else {
            switch collectionView {
            case filterCollectionView:
                if filterResponse?.filters?.availableCategories?.count == 0 {
                    return (filterResponse?.filters?.vendors?.vendors?.count ?? 0) + 1
                } else {
                    return (filterResponse?.filters?.availableCategories?.count ?? 0) + 1
                }
            default:
                if (productResponse?.listing?.products?.count ?? 0) == 0 { return 1 }
                else { return productResponse?.listing?.products?.count ?? 0 }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case filterCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.className, for: indexPath) as! CategoryCell
            if indexPath.row == 0 {
                cell.configureWithImage(title: "Refine")
            } else {
                if filterResponse?.filters?.availableCategories?.count == 0 {
                    let item = filterResponse?.filters?.vendors?.vendors?[indexPath.row - 1]
                    let isSelected = selectedVendors.contains(where: {$0 == item?.id})
                    cell.configureWith(title: item?.name ?? "", isSelected: isSelected)
                } else {
                    let item = filterResponse?.filters?.availableCategories?[indexPath.row - 1]
                    let isSelected = selectedCategories.contains(where: {$0 == item?.id})
                    cell.configureWith(title: item?.name ?? "", isSelected: isSelected)
                }
            }
            return cell
        default:
            if (productResponse?.listing?.products?.count ?? 0) == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyViewsCollectionViewCell.className, for: indexPath) as! EmptyViewsCollectionViewCell
                cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenProductsDescription)
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductItemCell.className, for: indexPath) as! ProductItemCell
                var item: Product?
                item = productResponse?.listing?.products?[indexPath.row]
                cell.configure(product: item)
                return cell
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case filterCollectionView:
            if indexPath.row == 0 { self.gotToFilter() }
            else {
                if filterResponse?.filters?.availableCategories?.count == 0 {
                    let item = filterResponse?.filters?.vendors?.vendors?[indexPath.row - 1]
                    self.selectVendor(id: item?.id ?? "")
                } else {
                    let item = filterResponse?.filters?.availableCategories?[indexPath.row - 1]
                    self.selectCategory(id: item?.id ?? 0)
                }
                self.fetchProductResponse(with: self.prepareFilters(self.selectedFilters) ?? [:])
            }
        default:
            if (productResponse?.listing?.products?.count ?? 0) == 0 {
                
            } else {
                var item: Product?
                item = productResponse?.listing?.products?[indexPath.row]
                let variant = item?.variants?.first(where: {$0.isDefault == true}) ?? item?.variants?.first
                self.goToProductDetail(of:item?.id ?? "", skuId: variant?.skuId ?? "")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case filterCollectionView:
            break
        default:
            var count = 0
            count = productResponse?.listing?.products?.count ?? 0
            
            if indexPath.row == (count - 3){
                if (repo?.pageNo ?? 0 + 1) <= productResponse?.listing?.paginationInfo?.totalPages ?? 0{
                    repo?.pageNo += 1
                    repo?.fetchProducts()
                    handleResponse()
                }
            }
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case filterCollectionView:
            let height = self.filterCollectionView.frame.height
            var width: CGFloat = 0
            if indexPath.row == 0 {
                width = calculateDynamicWidth(of: "Refine", padding: 32)
            } else {
                if filterResponse?.filters?.availableCategories?.count == 0 {
                    let vendors = filterResponse?.filters?.vendors?.vendors?[indexPath.row - 1]
                    width = calculateDynamicWidth(of: vendors?.name ?? "", padding: 32)
                } else {
                    let filter = filterResponse?.filters?.availableCategories?[indexPath.row - 1]
                    width = calculateDynamicWidth(of: filter?.name ?? "", padding: 32)
                }
            }
            return CGSize(width: width, height: height)
            
        default:
            if (productResponse?.listing?.products?.count ?? 0) == 0 {
                return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            }else{
                let interitemSpacesCount = numberOfItemPerRow - 1
                let interitemSpacingPerRow = minimumInteritemSpacing * CGFloat(interitemSpacesCount)
                let rowContentWidth = screenWidth - sectionInset.right - sectionInset.left - interitemSpacingPerRow
                
                let width = rowContentWidth / CGFloat(numberOfItemPerRow)
                //let height = width // feel free to change the height to whatever you want
                return CGSize(width: width, height: 300)
            }
        }
    }
}
