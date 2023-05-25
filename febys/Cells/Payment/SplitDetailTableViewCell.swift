//
//  SplitDetailTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 13/01/2022.
//

import UIKit

class SplitDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var splitAmountLabel: FebysLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(with billAmount: Price?) {
        var remaningPrice = Price()
        remaningPrice.currency = billAmount?.currency
        remaningPrice.value = billAmount?.amountAfterDeductionForSplit
        
        let price = "Choose Payment for remaining \(remaningPrice.formattedPrice() ?? "GHS 0.00")"
        self.splitAmountLabel.text = price
    }
    
}
