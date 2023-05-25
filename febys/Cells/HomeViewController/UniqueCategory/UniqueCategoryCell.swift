//
//  UniqueCategoryCell.swift
//  febys
//
//  Created by Waseem Nasir on 09/07/2021.
//

import UIKit


class UniqueCategoryCell: UICollectionViewCell {

    @IBOutlet weak var itemName: FebysLabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(category item: UniqueCategory?){
        if let url = item?.image?.first { self.mainImageView.setImage(url: url) }
        else { self.mainImageView.image = UIImage(named: "user") }
        itemName.text = item?.name ?? ""
    }
    
    func configure(endorsement item: Vendor?){
        if let url = item?.businessInfo?.logo {self.mainImageView.setImage(url: url)}
        else {self.mainImageView.image = UIImage(named: "user")}
        itemName.text = item?.name ?? ""
    }
}
