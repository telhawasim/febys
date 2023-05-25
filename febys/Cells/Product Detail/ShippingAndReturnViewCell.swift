//
//  ShippingAndReturnViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 09/02/2022.
//

import UIKit

class ShippingAndReturnViewCell: UIView {
    @IBOutlet weak var availabilityLabel: FebysLabel!
    @IBOutlet weak var fulfilledByLabel: FebysLabel!
    @IBOutlet weak var warrantyLabel: FebysLabel!
    @IBOutlet weak var warrantyDurationLabel: FebysLabel!
    @IBOutlet weak var returnNRefundLabel: FebysLabel!
    @IBOutlet weak var returnNRefundPolicyView: UIView!
    @IBOutlet weak var returnNRefundPolicyButton: FebysButton!
    
    func goToWebView() {
    
    }
    
    func configure(_ varient: Variant?){
        self.availabilityLabel.text = (varient?.availability ?? false) ? "In Stock" : "Out Of Stock"
        self.fulfilledByLabel.text = (varient?.fulfillmentByFebys ?? false) ? "Febys" : "Vendor"
        self.warrantyLabel.text = (varient?.warranty?.applicable ?? false) ? "Yes" : "No"
        
        let durationDays = varient?.warranty?.durationDays ?? 0
        let dayString = durationDays <= 1 ? "Day" : "Days"
        self.warrantyDurationLabel.text = "\(durationDays) \(dayString)"
        if let isRefundable = varient?.refund?.refundable {
            self.returnNRefundLabel.text = isRefundable ? "Yes" : "No"
            self.returnNRefundPolicyView.isHidden = isRefundable ? false : true

        }
    }
    
}
