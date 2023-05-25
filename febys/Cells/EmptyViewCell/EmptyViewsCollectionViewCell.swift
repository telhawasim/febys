//
//  EmptyViewsCollectionViewCell.swift
//  febys
//
//  Created by Nouman Akram on 11/02/2022.
//

import UIKit

class EmptyViewsCollectionViewCell: UICollectionViewCell {

    //MARK: Outlets
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: FebysLabel!
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: Configure Data
    func configure(title:String, description: String) {
        errorTitleLabel.text = title
        errorDescriptionLabel.text = description
    }
}
