//
//  CategoryViewController.swift
//  febys
//
//  Created by Waseem Nasir on 12/07/2021.
//

import UIKit
import XLPagerTabStrip

class CategoryListViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint:
    NSLayoutConstraint!
    @IBOutlet weak var cartCountLabel: FebysLabel!
    
    //MARK: PROPERTIES
    var titleName = ""
    var itemInfo: IndicatorInfo = ""
    var shouldFetchData = true
    var isLoading = true

    var pageNo = 1
    var categoryResponse: CategoryResponse?
    var categories: [Categories]?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        titleLabel.text = titleName
        
        if shouldFetchData{
            headerHeightConstraint.constant = 0
            fetchData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: .cartUpdated, object: nil)
        
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
    }
    
    @objc func updateCartCount(){
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        cartCountLabel.animate(duration: 0.3)

    }
    
    func registerCells() {
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.register(SearchListCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    //MARK: NAVIGATION
    func goToProductList(title: String, filterType: FilterType, _ repo: ProductRepository){
        let vc = UIStoryboard.getVC(from: .Product, ProductListViewController.className) as! ProductListViewController
        vc.titleName = title
        vc.filterType = filterType
        vc.repo = repo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API CALLS
    func fetchData(){
        let listingParams = [
            ParameterKeys.chunkSize: 20,
            ParameterKeys.pageNo: pageNo,
            ParameterKeys.queryStr: "",
            ParameterKeys.orderByCol: "created_at",
            ParameterKeys.orderByType: "asc"
        ] as [String : Any]
        
        let bodyParams = ["listing": listingParams]
        Loader.show()
        CategoryService.shared.allCategories(body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let categories):
                
                if self.categoryResponse == nil{
                    self.categoryResponse = categories
                }else{
                    self.categoryResponse?.listing?.categories?.append(contentsOf: categories.listing?.categories ?? [])
                }
                self.categories = self.categoryResponse?.listing?.categories
                self.isLoading = false
                self.tableView.reloadData()
                break
            case .failure(let error):
                self.isLoading = false
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: UITableView
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if categories?.count ?? 0 == 0 { return 1 }
            else { return categories?.count ?? 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if categories?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if categories?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenCategoriesDescription)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            let item = self.categories?[indexPath.row]
            cell.configure(category: item)
            cell.mainLabel.font = .helvetica(type: .medium, size: 13)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.categories?[indexPath.row]
        if let subCategory = item?.children, subCategory.count > 0{
            let vc = UIStoryboard.getVC(from: .Main, CategoryListViewController.className) as! CategoryListViewController
            vc.isLoading = false
            vc.shouldFetchData = false
            vc.categories = subCategory
            if self.titleName == ""{
                vc.titleName = item?.name ?? ""
            }else{
                vc.titleName = self.titleName + " / " + (item?.name ?? "")
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            if categories?.count ?? 0 == 0{
                
            }else{
                self.goToProductList(title: item?.name ?? "", filterType: .category(id: item?.id ?? 0), CategoryProductsRepository(item?.id ?? 0))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((categoryResponse?.listing?.categories?.count ?? 0) - 3){
            if (pageNo + 1) <= categoryResponse?.listing?.pagination_information?.totalPages ?? 0{
                pageNo += 1
                fetchData()
            }
        }
    }
}

//MARK: PAGER TAB DELEGATE
extension CategoryListViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
