//
//  CategoryCell.swift
//  febys
//
//  Created by Waseem Nasir on 11/07/2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: FebysLabel!
    @IBOutlet weak var filterImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: FeaturedCategoryResponse?){
        self.didHideFilterImage(true)
        self.configureState(isSelected: item?.isSelected ?? false)
        self.nameLabel.text = item?.name?.capitalized
    }
    
    func configureWith(title: String, isSelected: Bool, inverted: Bool = false){
        self.didHideFilterImage(true)
        self.configureState(isSelected: isSelected, inverted: inverted)
        nameLabel.text = title.capitalized
    }
    
    func configureWithImage(title: String) {
        self.didHideFilterImage(false)
        self.configureState(isSelected: false)
        self.nameLabel.text = title.capitalized
    }
        
    func didHideFilterImage(_ isHidden: Bool) {
        isHidden
        ? (self.filterImage.isHidden = true)
        : (self.filterImage.isHidden = false)
    }
    
    func configureState(isSelected: Bool, inverted: Bool = false) {
        if isSelected {
            containerView.backgroundColor = inverted ? .white : .febysLightGray()
            nameLabel.font = .helvetica(type: .medium, size: 12)
            containerView.borderWidth = 0
        }else{
            containerView.backgroundColor = inverted ? .clear : .white
            containerView.borderWidth = 1
            nameLabel.font = .helvetica(type: .regular, size: 12)
        }
    }
}
