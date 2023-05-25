//
//  VoucherViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 24/08/2022.
//

import UIKit

class VoucherViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var voucherTextField: FebysTextField!
    @IBOutlet weak var applyButton: FebysButton!
    
    
    //MARK: CONFIGURE
    func configure(_ voucher: Voucher?) {
        if voucher != nil {
            self.voucherTextField.text = voucher?.code ?? ""
            self.voucherTextField.isUserInteractionEnabled = false
            self.applyButton.isSelected = true
            self.applyButton.backgroundColor = .febysRed()
        } else {
            self.voucherTextField.text = ""
            self.voucherTextField.isUserInteractionEnabled = true
            self.applyButton.isSelected = false
            self.applyButton.backgroundColor = .febysBlack()
        }
    }
    
}
