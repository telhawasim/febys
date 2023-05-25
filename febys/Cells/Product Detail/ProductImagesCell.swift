//
//  ProductImagesCell.swift
//  febys
//
//  Created by Waseem Nasir on 13/07/2021.
//

import UIKit

class ProductImagesCell: UICollectionViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var mainImageView: UIImageView!
    
    //MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Map Data
    func configure(_ item: String?){
        if let url = item { self.mainImageView.setImage(url: url) }
        else { self.mainImageView.image = UIImage(named: "no-image") }
        self.mainImageView.contentMode = .scaleAspectFit
    }
}
