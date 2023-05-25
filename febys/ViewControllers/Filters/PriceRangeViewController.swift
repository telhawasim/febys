//
//  PriceRangeViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 03/01/2022.
//

import UIKit
protocol PriceRangeDelegate {
    func didRemovePriceRange(forKey: String)
    func setPriceRange(minimum: Double, maximum: Double, forKey: String)
}

class PriceRangeViewController: BaseViewController {

    //MARK: IBOutlet
    @IBOutlet var currencyLabels: [FebysLabel]!
    @IBOutlet weak var minPriceField: FebysTextField!
    @IBOutlet weak var maxPriceField: FebysTextField!
    @IBOutlet weak var applyNowButton: FebysButton!
    @IBOutlet weak var clearButton: FebysButton!

    var key = ""
    var clearPrice = false
    var priceRange: [String:[Any]] = [:]
    var delegate: PriceRangeDelegate?
  
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtonActions()
        let minPrice = priceRange[ParameterKeys.minimum]?.first
        let maxPrice = priceRange[ParameterKeys.maximum]?.first
        
        if let min = minPrice {
            if (min as! Double) == 0.0 {
                self.minPriceField.text = ""
            } else {
                self.minPriceField.text = "\(min)"
            }
        }
        
        if let max = maxPrice {
            if (max as! Double) == 0.0 {
                self.maxPriceField.text = ""
            } else {
                self.maxPriceField.text = "\(max)"
            }
        }
        
    }
    
    //MARK: IBActions
    func setupButtonActions() {
        self.applyNowButton.didTap = { [weak self] in
            guard let self = self else { return }
            if self.clearPrice {
                self.delegate?.didRemovePriceRange(forKey: self.key)
                self.backButtonTapped(self)
            } else {
                self.delegate?.setPriceRange(minimum: self.minPriceField.text?.toDouble() ?? 0.0, maximum: self.maxPriceField.text?.toDouble() ?? 0.0, forKey: self.key)
                self.backButtonTapped(self)
            }
        }
        
        self.clearButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.minPriceField.text = ""
            self.maxPriceField.text = ""
        }
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
