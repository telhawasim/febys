//
//  EmptyListHeaderView.swift
//  febys
//
//  Created by Faisal Shahzad on 26/07/2022.
//

import UIKit

class EmptyListHeaderView: UITableViewHeaderFooterView {

    //MARK: Outlets
    @IBOutlet weak var errorIconImage: UIImageView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: FebysLabel!
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(icon: String, title:String, description: String) {
        errorIconImage.image = UIImage(named: icon)
        errorTitleLabel.text = title
        errorDescriptionLabel.text = description
    }

}
