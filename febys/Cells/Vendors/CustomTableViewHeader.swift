//
//  CustomTableViewHeader.swift
//  febys
//
//  Created by Abdul Kareem on 13/09/2021.
//

import UIKit

class CustomTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: FebysLabel!
    @IBOutlet weak var labelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
