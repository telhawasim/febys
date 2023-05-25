//
//  CheckoutTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 15/09/2021.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var cellTitle: FebysLabel!
    @IBOutlet weak var cellDetail: FebysLabel!
    
    //MARK: CONFIGURE
    func configure(title: String, description: String) {
        self.cellTitle.text = title
        self.cellDetail.text = description
    }
}
