//
//  ChooseLocationTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 17/08/2022.
//

import UIKit

class ChooseLocationTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    
    //MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(icon: UIImage, title: String, size: CGFloat = 20.0) {
        self.icon.image = icon
        self.title.text = title.capitalized
        
        iconWidthConstraint.constant = size
        iconHeightConstraint.constant = size
    }
}
