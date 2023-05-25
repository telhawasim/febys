//
//  CelebrityViewController.swift
//  febys
//
//  Created by Ab Saqib on 01/09/2021.
//

import UIKit
import XLPagerTabStrip

class CelebrityDetailViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var cartCountLabel: FebysLabel!
    @IBOutlet weak var celebrityNameLabel: FebysLabel!
    @IBOutlet weak var celebrityProductsCountLabel: FebysLabel!
    
    //MARK: PROPERTIES
    var totalRows = 0
    var pageNo = 1
    var pageSize = 15

    var selectedFilters: [String:[String:[Any]]] = [:]
    var selectedVendors: [String] = []
    var selectedCategories: [Int] = []
    var filterResponse: FiltersResponse?
    
    var itemInfo: IndicatorInfo = ""
    var celebrityID: String?
    var productResponse: ProductResponse?
    var celebrity: Vendor?
    var endorsements: VendorListing?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCelebrityDetailsBy(id: celebrityID ?? "")
        fetchCelebrityEndorsementBy(id: celebrityID ?? "")
        fetchCelebrityProductListBy(id: celebrityID ?? "")
        fetchCelebrityProductFiltersBy(id: celebrityID ?? "")
        
        setupButton()
        configureTableView()
        configureCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cartCountLabel.text = "\(CartEntity.getAllCartItems())"
    }
    
    //MARK: IBActions
    func setupButton(){
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
    }
    
    //MARK: Register Cell
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(VendorDetailTableViewCell.className)
        tableView.register(UniqueCatergoryTableViewCell.className)
        tableView.register(VendorProductTableViewCell.className)
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20,  bottom: 0, right: 20)
        collectionView.register(CategoryCell.className)
    }
    
    
    //MARK: Helpers
    private func selectCategory(id: Int) {
        if !(filterResponse?.filters?.availableCategories?.count == 0) {
            if selectedCategories.contains(where: {$0 == id}) {
                selectedCategories.removeAll(where: {$0 == id})
            } else {
                selectedCategories.append(id)
            }
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
    
    //MARK: Navigation
    func goToProductDetailBy(id: String, skuId: String) {
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = id
        vc.preferredSkuId = skuId
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
    
    func goToVendorDetail(of vendorId: String?) {
        let vc = UIStoryboard.getVC(from: .VendorStore, VendorDetailViewController.className) as! VendorDetailViewController
        vc.vendorId = vendorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCelebrityDetail(id: String){
        let vc = UIStoryboard.getVC(from: .VendorStore, CelebrityDetailViewController.className) as! CelebrityDetailViewController
        vc.celebrityID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Prepare Filters
    func preparePriceRangeFrom(_ filters:[String:[String:[Any]]]) -> [String:Any]? {
        let key = ParameterKeys.variants_price_value
        var range: [String:Any]? = [:]
        if let min = filters[key]?[ParameterKeys.minimum]?.first {
            if (min as? Double) != 0.0 { range?[ParameterKeys.greaterThen] = min }
        }
        if let max = filters[key]?[ParameterKeys.maximum]?.first {
            if (max as? Double) != 0.0 { range?[ParameterKeys.lessThen] = max }
        }
        return range
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
            if !price.isEmpty { filter[ParameterKeys.variants_price_value] = price }
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
    
    
    //MARK: API Calling
    func fetchCelebrityDetailsBy(id: String){
        Loader.show()
        CelebrityService.shared.getCelebrityDetails(id: id) { response in
            Loader.dismiss()
            switch response{
            case .success(let celebrity):
                self.celebrity = celebrity
                self.celebrityNameLabel.text = celebrity.name?.capitalized ?? ""
                self.tableView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchCelebrityEndorsementBy(id: String){
        CelebrityService.shared.getMyEndorsement(id: id) { response in
            switch response{
            case .success(let endorsements):
                self.endorsements = endorsements
                self.tableView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchCelebrityProductListBy(id: String, filters: [String:[String:Any]] = [:]){
        var filter = filters
        let params = [ParameterKeys.chunkSize: pageSize, ParameterKeys.pageNo: pageNo]
        let defaultKey = ParameterKeys.variants_default
        let attributeKey = ParameterKeys.variants_attributes_value
        
        if let _ = filter[ParameterKeys.filters]?[attributeKey] {
            filter[ParameterKeys.filters]?[defaultKey] = nil
        } else {
            filter[ParameterKeys.filters]?[defaultKey] = true
        }
        
        var bodyParams: [String:Any] = [:]
        if let filtr = filter[ParameterKeys.filters] {
             bodyParams[ParameterKeys.filters] = filtr
        }
        if let sorter = filters[ParameterKeys.sorter] {
            bodyParams[ParameterKeys.sorter] = sorter
        }
        
        
        CelebrityService.shared.getCelebrityProductListing(id: id, body: bodyParams, params: params) { response in
            switch response{
            case .success(let productResponse):
                self.totalRows = productResponse.listing?.totalRows ?? 0
                let item = self.totalRows == 1 ? "item" : "items"
                self.celebrityProductsCountLabel.text = "\(self.totalRows) \(item)"
                
                if self.productResponse == nil{
                    self.productResponse = productResponse
                }else{
                    self.productResponse?.listing?.products?.append(contentsOf: productResponse.listing?.products ?? [])
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func fetchCelebrityProductFiltersBy(id: String) {
        Loader.show()
        FilterService.shared.fetchVendorProductFiltersBy(id: id) { response in
            Loader.dismiss()
            switch response {
            case .success(let filterResponse):
                self.filterResponse = filterResponse
                self.collectionView.reloadData()
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: FilterDelegate
extension CelebrityDetailViewController : FilterDelegate {
    func didApplyFilters(filters: [String:[String:[Any]]]) {
        self.productResponse = nil
        self.selectedFilters = filters
        self.fetchCelebrityProductListBy(id: celebrityID ?? "", filters: self.prepareFilters(filters) ?? [:])
    }
}

//MARK: CelebrityDelegate
extension CelebrityDetailViewController: CelebrityProductDelegate {
    func productDetail(of id: String, skuId: String) {
        self.goToProductDetailBy(id: id, skuId: skuId)

    }
}

//MARK: TableView Methods
extension CelebrityDetailViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VendorDetailTableViewCell.className, for: indexPath) as! VendorDetailTableViewCell
            cell.configure(celebrity, forVendor: false)
        
            cell.followButton.didTap = { [weak self] in
                guard let self = self else { return }
                if cell.followButton.isSelected {
                    self.showMessage(Constants.areYouSure, Constants.youWantToUnfollowVendor, messageImage: .follow, isQuestioning: true, onSuccess:{
                        FollowingListManager.shared.followOrUnfollowVendor(cell.followButton, by: self.celebrity?.id ?? "")
                    }, onDismiss: nil)
                } else {
                    FollowingListManager.shared.followOrUnfollowVendor(cell.followButton, by: self.celebrity?.id ?? "")
                }
            }
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UniqueCatergoryTableViewCell.className, for: indexPath) as! UniqueCatergoryTableViewCell
            cell.configure(endorsments: self.endorsements?.vendors)
            
            cell.didSelectVendor = { [weak self] vendor in
                if vendor.role?.name == Constants.CelebrityInfluencer {
                    self?.goToCelebrityDetail(id: vendor.id ?? "")
                } else {
                    self?.goToVendorDetail(of: vendor.id ?? "")
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: VendorProductTableViewCell.className, for: indexPath) as! VendorProductTableViewCell
            cell.delegate = self
            cell.configure(productResponse?.listing?.products)
            return cell
        }
    }
}


//MARK: UICollectionViewDelegate & UICollectionViewDataSource
extension CelebrityDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (filterResponse?.filters?.availableCategories?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.className, for: indexPath) as! CategoryCell
        if indexPath.row == 0 {
            cell.configureWithImage(title: "Refine")
        } else {
            let item = filterResponse?.filters?.availableCategories?[indexPath.row - 1]
            let isSelected = selectedCategories.contains(where: {$0 == item?.id})
            cell.configureWith(title: item?.name ?? "", isSelected: isSelected)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.gotToFilter()
        } else {
            let item = filterResponse?.filters?.availableCategories?[indexPath.row - 1]
            self.selectCategory(id: item?.id ?? 0)
            self.productResponse = nil
            self.fetchCelebrityProductListBy(id: celebrityID ?? "", filters: self.prepareFilters(self.selectedFilters) ?? [:])
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension CelebrityDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.collectionView.frame.height
        var width: CGFloat = 0
        if indexPath.row == 0 {
            width = calculateDynamicWidth(of: "Refine", padding: 32)
        } else {
            let filter = filterResponse?.filters?.availableCategories?[indexPath.row - 1]
            width = calculateDynamicWidth(of: filter?.name ?? "", padding: 32)
        }
        return CGSize(width: width, height: height)
    }
}
