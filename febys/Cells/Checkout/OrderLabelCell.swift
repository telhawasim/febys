//
//  OrderLabelCell.swift
//  febys
//
//  Created by Faisal Shahzad on 23/08/2022.
//

import UIKit

class OrderLabelCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
}
