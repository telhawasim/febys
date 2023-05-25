//
//  StoresViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 16/12/2021.
//

import UIKit
import XLPagerTabStrip

class StoresViewController: BaseViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: PROPERTIES
    var itemInfo: IndicatorInfo = ""
    var isLoading = true

    var pageNo = 1
    var menuResponse: MenuResponse?
    var vendorStores: [NavigationMenu]? = []
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.fetchStores()
    }
    
    //MARK: Helper
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.register(SearchListCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    //MARK: Navigation
    func goToStoreTemplate(with templateId: String, title: String) {
        let vc = UIStoryboard.getVC(from: .Main, StoreTemplateViewController.className) as! StoreTemplateViewController
        vc.templateId = templateId
        vc.titleName = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API Calling
    func fetchStores(){
        Loader.show()
        MenuService.shared.fetchAllMenu() { response in
            Loader.dismiss()
            switch response{
            case .success(let menu):
                self.menuResponse = menu.first
                if let stores = self.menuResponse?.navigationMenu {
                    self.vendorStores?.removeAll()
                    for store in stores {
                        if store.template != "" {
                            self.vendorStores?.append(store)
                        }
                    }
                }
                
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
extension StoresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if vendorStores?.count ?? 0 == 0{ return 1 }
            else {  return vendorStores?.count ?? 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vendorStores?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vendorStores?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenStoresDescription)
            return cell
        }else{
            let item = self.vendorStores?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            cell.configure(store: item)
            cell.mainLabel.font = .helvetica(type: .medium, size: 13)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vendorStores?.count ?? 0 == 0{
            
        } else {
            let item = self.vendorStores?[indexPath.row]
            let templateId = item?.template?.components(separatedBy: ",")
            self.goToStoreTemplate(with: templateId?.last ?? "", title: item?.name ?? "")
        }
    }
}

//MARK: PAGER TAB DELEGATE
extension StoresViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

