//
//  ProductSections.swift
//  febys
//
//  Created by Faisal Shahzad on 24/09/2021.
//

import UIKit

struct ExpandingCell {
    var isExpanded : Bool
    let sectionTitle: String
    let tableViewCell : UITableViewCell? = UITableViewCell()
    
    static func getProductSeactions() -> [ExpandingCell] {
        let data = [
            ExpandingCell(isExpanded: true,
                          sectionTitle: Constants.description),
            ExpandingCell(isExpanded: false,
                          sectionTitle: Constants.manufacturer),
            ExpandingCell(isExpanded: false,
                          sectionTitle: Constants.reviews),
            ExpandingCell(isExpanded: false,
                          sectionTitle: Constants.qNa),
            ExpandingCell(isExpanded: false,
                          sectionTitle: Constants.shippingFeeAndRetuns)
        ]
        return data
    }
    
}



