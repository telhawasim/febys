//
//  VendorListViewController.swift
//  febys
//
//  Created by Ab Saqib on 07/09/2021.
//

import UIKit
import XLPagerTabStrip

class VendorListViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: PROPERTIES
    var totalRows = 0
    var pageNo = 1
    var pageSize = 15
    var isLoading = true

    var isCelebrityListing = false
    var isFollowUpdated = false
    var itemInfo: IndicatorInfo = ""
    var followedVendors: VendorListing?
    var vendors: VendorResponse?
    var vendorData: [VendorsData] = []
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.fetchFollowedVendors()
        self.fetchVendors()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFollow), name: .followUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFollowUpdated {
            self.fetchFollowedVendors()
            self.fetchVendors()
        }
    }
    
    //MARK: Helpers
    @objc func updateFollow() {
        self.isFollowUpdated = true
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        tableView.sectionFooterHeight = .leastNormalMagnitude
        
        tableView.register(VendorTableViewCell.className)
        tableView.registerHeaderFooter(CustomTableViewHeader.className)
        tableView.register(EmptyViewsTableViewCell.className)
        
    }
    
    //MARK: Navigation
    func goToVendorProductList(storeName: String, vendorRole: String, filterType: FilterType, _ repo: ProductRepository) {
        let vc = UIStoryboard.getVC(from: .Product, ProductListViewController.className) as! ProductListViewController
        vc.filterType = filterType
        vc.storeName = storeName
        vc.vendorRole = vendorRole
        vc.repo = repo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToCelebrityDetail(id: String){
        let vc = UIStoryboard.getVC(from: .VendorStore, CelebrityDetailViewController.className) as! CelebrityDetailViewController
        vc.celebrityID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API Calling
    func fetchFollowedVendors(){
        if User.fetch() != nil {
            Loader.show()
            if isCelebrityListing {
                CelebrityService.shared.getFollowedCelebrityList { response in
                    Loader.dismiss()
                    switch response{
                    case .success(let celebrities):
                        self.followedVendors = celebrities
                        self.isLoading = false
                        self.prepareData()
                    case .failure(let error):
                        self.isLoading = false
                        self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                    }
                }
            } else {
                VendorService.shared.getFollowedVendorList { response in
                    Loader.dismiss()
                    switch response{
                    case .success(let follower):
                        self.followedVendors = follower
                        self.isLoading = false
                        self.prepareData()
                    case .failure(let error):
                        self.isLoading = false
                        self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                    }
                }
            }
        }
    }
    
    func fetchVendors(){
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo: pageNo] as [String : Any]
        
        Loader.show()
        if isCelebrityListing {
            CelebrityService.shared.getCelebrityListing(isRecommended: User.fetch() != nil, params: params) { response in
                Loader.dismiss()
                switch response{
                case .success(let celebrities):
                    self.totalRows = celebrities.listing?.total_rows ?? 0
                    if self.vendors == nil{
                        self.vendors = celebrities
                    }else{
                        if self.isFollowUpdated {
                            self.isFollowUpdated = false
                            self.vendors = celebrities
                        } else{
                            self.vendors?.listing?.vendors?.append(contentsOf: celebrities.listing?.vendors ?? [])
                        }
                    }
                    self.isLoading = false
                    self.prepareData()
                case .failure(let error):
                    self.isLoading = false
                    self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                }
            }
        } else {
            VendorService.shared.getVendorListing(isRecommended: User.fetch() != nil, params: params) { response in
                Loader.dismiss()
                switch response{
                case .success(let vendors):
                    self.totalRows = vendors.listing?.total_rows ?? 0
                    if self.vendors == nil{
                        self.vendors = vendors
                    } else {
                        if self.isFollowUpdated {
                            self.isFollowUpdated = false
                            self.vendors = vendors
                        } else{
                            self.vendors?.listing?.vendors?.append(contentsOf: vendors.listing?.vendors ?? [])
                        }
                    }
                    self.isLoading = false
                    self.prepareData()
                case .failure(let error):
                    self.isLoading = false
                    self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
                }
            }
        }
    }
    
    //MARK: PrepareData
    func prepareData() {
        vendorData.removeAll()
        
        var following: [Vendor]?
        if isCelebrityListing {
            following = self.followedVendors?.celebs
        } else {
            following = self.followedVendors?.stores
        }
        
        if let followerList = following {
            if !followerList.isEmpty {
                vendorData.append(.followedVendors(followerList))
            }
        }
        
        if let vendorList = self.vendors?.listing?.vendors {
            if !vendorList.isEmpty {
                vendorData.append(.vendors(vendorList))
            }
        }
        
        tableView.reloadData()
    }
}

//MARK: TableView Methods
extension VendorListViewController: UITableViewDelegate, UITableViewDataSource{
   func numberOfSections(in tableView: UITableView) -> Int {
        return vendorData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if vendorData.count == 0{
                return 1
            } else {
                switch vendorData[section] {
                case .followedVendors(let followedVendors):
                    return followedVendors.count
                case .vendors(let vendors):
                    return vendors.count
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vendorData.count == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeader.className) as! CustomTableViewHeader
        view.topConstraint.constant = 0.0
        view.bottomContraint.constant = 0.0
       
        switch vendorData[section] {
        case .followedVendors(_):
            view.headerLabel.text = isCelebrityListing ? Constants.marketsYouFollowSection : Constants.storesYouFollowSection
        case .vendors(_):
            view.headerLabel.text = isCelebrityListing ? Constants.exploreMarketsSection : Constants.exploreStoresSection
        }
       
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vendorData.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenVendorsDescription)
            return cell
        }else{
            switch vendorData[indexPath.section] {
            case .followedVendors(let followedVendors):
                let cell = tableView.dequeueReusableCell(withIdentifier: VendorTableViewCell.className, for: indexPath) as! VendorTableViewCell
                let item = followedVendors[indexPath.row]
                cell.configure(item, isFollowing: true, isVendor: !isCelebrityListing)
                
                cell.storeFollowButton.didTap = { [weak self] in
                    guard let self = self else { return }
                    if cell.storeFollowButton.isSelected {
                        let message = self.isCelebrityListing
                                        ? Constants.youWantToUnfollowCelebrity
                                        : Constants.youWantToUnfollowVendor
                        
                        self.showMessage(Constants.areYouSure, message, messageImage: .follow, isQuestioning: true, onSuccess: {
                            FollowingListManager.shared.followOrUnfollowVendor(cell.storeFollowButton, by: item.id ?? "")
                        }, onDismiss: nil)
                    } else {
                        FollowingListManager.shared.followOrUnfollowVendor(cell.storeFollowButton, by: item.id ?? "")
                    }
                }
                
                return cell
                
            case .vendors(let vendors):
                let cell = tableView.dequeueReusableCell(withIdentifier: VendorTableViewCell.className, for: indexPath) as! VendorTableViewCell
                let item = vendors[indexPath.row]
                cell.configure(item, isFollowing: false, isVendor: !isCelebrityListing)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch vendorData[indexPath.section] {
        case .followedVendors(_):
            break
        case .vendors(let vendors):
            if indexPath.row == ((vendors.count) - 3){
                if (pageNo + 1) <= self.vendors?.listing?.pagination_info?.totalPages ?? 0{
                    pageNo += 1
                    fetchVendors()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vendorData.count == 0 {
            
        } else {
            var vendor: Vendor?
            switch vendorData[indexPath.section] {
            case .followedVendors(let followed):
                vendor = followed[indexPath.row]
            case .vendors(let vendors):
                vendor = vendors[indexPath.row]
            }
            
            if isCelebrityListing {
                self.goToCelebrityDetail(id: vendor?.id ?? "")
            } else {
                self.goToVendorProductList(storeName: vendor?.shopName ?? "", vendorRole: vendor?.role?.name ?? "", filterType: .vendorProduct(vendorId: vendor?.id ?? ""), VendorProductsRepository(vendor?.id ?? ""))
            }
        }
    }
}

//MARK: PAGER TAB DELEGATE
extension VendorListViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

enum VendorsData {
    case followedVendors([Vendor])
    case vendors([Vendor])
}
