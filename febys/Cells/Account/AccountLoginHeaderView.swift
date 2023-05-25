//
//  AccountLoginHeaderView.swift
//  febys
//
//  Created by Faisal Shahzad on 13/09/2021.
//

import UIKit

class AccountLoginHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var signInButton: FebysButton!
    @IBOutlet weak var signUpButton: FebysButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
