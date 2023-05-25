//
//  ShippingMethodsViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 24/08/2022.
//

import UIKit

protocol ShippingMethodDelegate {
    func didSelectShippingMethod(_ estimate: Estimate)
}

class ShippingMethodsViewController: BaseViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: FebysButton!

    
    //MARK: PROPERTIES
    var selectedEstimate: Estimate?
    var swooveResponse: SwooveResponse?
    var delegate: ShippingMethodDelegate?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        saveButton.didTap = { [weak self] in
            if let estimate = self?.selectedEstimate {
                self?.delegate?.didSelectShippingMethod(estimate)
                self?.backButtonTapped(self!)
            }
        }
    }
    
    //MARK: METHODS
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ShippingMethodTableViewCell.className)
    }
    
}

//MARK: UITableView
extension ShippingMethodsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swooveResponse?.estimates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShippingMethodTableViewCell.className, for: indexPath) as! ShippingMethodTableViewCell
        
        let item = swooveResponse?.estimates?[indexPath.row]
        let isSelected = item?.estimateId == selectedEstimate?.estimateId
        cell.configure(item, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var indexes = [indexPath]
        if let previous = swooveResponse?.estimates?.firstIndex(where: { $0.estimateId == selectedEstimate?.estimateId }) {
            
            let previousIndex = IndexPath(row: previous, section: indexPath.section)
            indexes.append(previousIndex)
            
        }
        
        selectedEstimate = swooveResponse?.estimates?[indexPath.row]
        tableView.reloadRows(at: indexes, with: .automatic)
    }
    
}
