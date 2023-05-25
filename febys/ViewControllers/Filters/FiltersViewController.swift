//
//  FiltersViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 16/12/2021.
//

import UIKit
import SwiftUI
  
protocol AttributesDelegate {
    func didSetSelected(attributes: [Any], forKey: String, childKey: String)
    func didRemoveAttribute(key: String)
}

protocol FilterDelegate {
    func didApplyFilters(filters: [String:[String:[Any]]])
}

struct SortingData: Equatable {
    let key: String
    let value: String
    
    static func getSortingList() -> [SortingData] {
        var data: [SortingData] = []
        data.append(SortingData(key: "new", value: "New Items"))
        data.append(SortingData(key: "asc", value: "Price ( low first )"))
        data.append(SortingData(key: "desc", value: "Price ( high first )"))
        return data
    }
}

class FiltersViewController: BaseViewController {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: FebysLabel!
    @IBOutlet weak var clearAllButton: FebysButton!
    @IBOutlet weak var applyNowButton: FebysButton!
    
    //MARK: Properties
    var showAttributes = false
    var delegate: AttributesDelegate?
    var filterDelegate: FilterDelegate?
    var filters: Filters?
    var attribute: Attributes?
    var sortingList = SortingData.getSortingList()
    
    var key = ""
    var selectedFilters: [String:[String:[Any]]] = [:]
    var values: [String] = []


    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.setupButtonActions()
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureClearAllButton()
    }
    
    //MARK: IBActions
    func setupButtonActions() {
        self.applyNowButton.didTap = { [weak self] in
            guard let self = self else { return }
            if self.showAttributes {
                let childKey = self.attribute?.name ?? ""
                self.delegate?.didSetSelected(attributes: self.selectedFilters[self.key]?[childKey] ?? [], forKey: self.key, childKey: childKey)
                self.backButtonTapped(self)
            } else {
                self.filterDelegate?.didApplyFilters(filters: self.selectedFilters)
                self.backButtonTapped(self)

            }
        }
        
        self.clearAllButton.didTap = { [weak self] in
            guard let self = self else { return }
            if self.showAttributes {
                self.values.removeAll()
                self.selectedFilters[self.key] = nil
                self.tableView.reloadData()
            } else {
                self.selectedFilters.removeAll()
                self.tableView.reloadData()
            }
            self.configureClearAllButton()
        }
    }
    
    
    //MARK: Helpers
    func configureNavBar() {
        if showAttributes {
            self.titleLabel.text = attribute?.name?.capitalized ?? ""
            self.clearAllButton.setTitle("Clear", for: .normal)
        } else {
            self.titleLabel.text = "Refine"
            self.clearAllButton.setTitle("Clear All", for: .normal)
        }
    }
    
    func configureClearAllButton() {
        if !selectedFilters.isEmpty {
            self.clearAllButton.isEnabled = true
        } else {
            self.clearAllButton.isEnabled = false
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

        tableView.register(SearchListCell.className)
        tableView.registerHeaderFooter(CustomTableViewHeader.className)
    }
    
    //MARK: Navigation
    func gotToFilterAttribute(with attribute: Attributes?) {
        let vc = UIStoryboard.getVC(from: .Filters, FiltersViewController.className) as! FiltersViewController
        vc.key = ParameterKeys.variants_attributes_value
        vc.delegate = self
        vc.showAttributes = true
        vc.attribute = attribute
        vc.selectedFilters = selectedFilters
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func gotToPriceRange() {
        let vc = UIStoryboard.getVC(from: .Filters, PriceRangeViewController.className) as! PriceRangeViewController
        vc.key = ParameterKeys.variants_price_value
        vc.delegate = self
        vc.priceRange = selectedFilters[ParameterKeys.variants_price_value] ?? [:]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isValueSelected(_ value: String, forKey: String) -> Bool {
        if let values = selectedFilters[self.key]?[forKey] {
            return values.contains(where: { ($0 as! String) == value})
        }
        return false
    }
    
}

extension FiltersViewController: AttributesDelegate {
    func didSetSelected(attributes: [Any], forKey: String, childKey: String) {
        if self.selectedFilters[forKey] == nil {
            self.selectedFilters[forKey] = [childKey: attributes]
        } else {
            self.selectedFilters[forKey]?.updateValue(attributes, forKey: childKey)
        }
        self.tableView.reloadData()
    }
    
    func didRemoveAttribute(key: String) {
        self.selectedFilters[key] = nil
        self.tableView.reloadData()
    }
}

//MARK: PriceRangeDelegate
extension FiltersViewController: PriceRangeDelegate {
    func didRemovePriceRange(forKey: String) {
        self.selectedFilters[forKey] = nil
    }
    
    func setPriceRange(minimum: Double, maximum: Double, forKey: String) {
        let range = [ParameterKeys.minimum: [minimum],
                     ParameterKeys.maximum: [maximum]]
       
        if self.selectedFilters[forKey] == nil {
            self.selectedFilters[forKey] = range
        } else {
            self.selectedFilters.updateValue(range, forKey: forKey)
        }
    }
}

//MARK: UITableView
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if showAttributes { return 1 }
        else { return 2 }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAttributes {
            return self.attribute?.values?.count ?? 0
        } else {
            if section == 0 {
                return self.sortingList.count
            } else {
                return ((self.filters?.attributes?.attributes?.count ?? 0) + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !showAttributes {
            if section > 0 {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeader.className) as! CustomTableViewHeader
                
                header.labelViewHeight.constant = 20
                header.bottomContraint.constant = 25
                header.headerLabel.text = Constants.filterBy
                header.headerLabel.font = UIFont.helvetica(type: .medium, size: 16)
                return header
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showAttributes {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            let item = self.attribute?.values?[indexPath.row]
            let isSeleted = self.isValueSelected(item ?? "", forKey: self.attribute?.name ?? "")
            cell.configure(filters: item, withRadioButton: false, isSelected: isSeleted)
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
                let item = self.sortingList[indexPath.row]
                var isSelected = false
                
                if let key = self.selectedFilters[ParameterKeys.sorter]? [ParameterKeys.variants_price_value]?.first {
                    isSelected = (key as! String) == item.key
                }

                cell.configure(filters: item.value, withRadioButton: true, isSelected: isSelected)
                return cell
            } else {
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
                    cell.configure(title: "Price Range", subTitle: nil, withArrow: true)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
                    let item = self.filters?.attributes?.attributes?[indexPath.row]
                    cell.configure(title: item?.name, subTitle: ((selectedFilters[item?.name ?? ""] as? String) ?? nil), withArrow: true)
                    return cell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showAttributes {
            let childKey = self.attribute?.name ?? ""
            let item = self.attribute?.values?[indexPath.row] ?? ""
            
            if let values = selectedFilters[key]?[childKey] {
                self.values = (values as! [String])
            }
            
            if let i = values.firstIndex(where:{$0 == item}) {
                self.values.remove(at: i)
            } else {
                self.values.append(item)
            }
            
            self.selectedFilters[self.key] = [childKey:values]
            self.configureClearAllButton()
            self.tableView.reloadData()
        } else {
            if indexPath.section == 0 {
                let childKey = ParameterKeys.variants_price_value
                let value = self.sortingList[indexPath.row].key
                
                self.selectedFilters[ParameterKeys.sorter] = [childKey:[value]]
                self.configureClearAllButton()
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
            } else {
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                    self.gotToPriceRange()
                } else {
                    self.gotToFilterAttribute(with: self.filters?.attributes?.attributes?[indexPath.row])
                }
            }
        }
    }
    
}

enum FilterType {
    case category(id: Int)
    case todayDeal
    case under100
    case searchProduct(searchStr: String)
    case vendorProduct(vendorId: String)
    case none
}
