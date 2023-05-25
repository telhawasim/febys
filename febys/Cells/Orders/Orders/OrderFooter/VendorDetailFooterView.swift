//
//  VendorDetailFooterView.swift
//  febys
//
//  Created by Faisal Shahzad on 04/02/2022.
//

import UIKit

class VendorDetailFooterView: UITableViewHeaderFooterView {
    //MARK: IBOutlet
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var storeNameStackView: UIStackView!
    @IBOutlet weak var addressStackView: UIStackView!
    
    @IBOutlet weak var storeNameLabel: FebysLabel!
    @IBOutlet weak var storeAddressLabel: FebysLabel!

    //MARK: Configure
    func configure(_ vendor: Vendor?) {
        print("Height before: \(mainStackView.frame.height)")

        self.storeNameLabel.text = vendor?.shopName ?? ""
        self.storeAddressLabel.text = vendor?.businessInfo?.address ?? ""


        
//        self.storeNameStackView.layoutIfNeeded()
//        self.addressStackView.layoutIfNeeded()
//        self.mainStackView.layoutIfNeeded()
        
        print("Height after: \(mainStackView.frame.height)")
    }
}
