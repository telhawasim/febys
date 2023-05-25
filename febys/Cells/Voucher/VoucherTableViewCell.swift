//
//  VoucherTableViewCell.swift
//  febys
//
//  Created by Abdul Kareem on 11/10/2021.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var voucherTypeLabel: FebysLabel!
    @IBOutlet weak var voucherAmountLabel: FebysLabel!
    @IBOutlet weak var voucherCodeLabel: FebysLabel!
    @IBOutlet weak var voucherDateLabel: FebysLabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ voucher: Vouchers?) {
        self.voucherTypeLabel.text = voucher?.voucher?.amountType ?? ""
        
        var voucherAmount = Price()
        voucherAmount.currency = "GHS"
        voucherAmount.value = voucher?.voucher?.amount ?? 0.0
        
        self.voucherAmountLabel.text = voucherAmount.formattedPrice()
        self.voucherCodeLabel.text = voucher?.voucher?.code ?? ""
        if let date = voucher?.voucher?.endDate {
            self.voucherDateLabel.text = Date.getFormattedDate(string: date, format: Constants.dateFormatMMMddyyyy)
        }

    }
    
}
