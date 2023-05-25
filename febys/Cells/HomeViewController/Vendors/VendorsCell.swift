//
//  VendorsCell.swift
//  febys
//
//  Created by Faisal Shahzad on 12/05/2022.
//

import UIKit
import Cosmos

class VendorsCell: UICollectionViewCell {
    //MARK: OUTLETS
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: FebysLabel!
    @IBOutlet weak var officialBadgeImage: UIImageView!
    @IBOutlet weak var storeRatingView: CosmosView!
    
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(vendor: Vendor?) {
        self.storeNameLabel.text = vendor?.name ?? ""
        self.storeRatingView.rating = vendor?.stats?.rating?.score ?? 0.0

        if let url = vendor?.businessInfo?.logo {
            self.storeImageView.setImage(url: url)
        } else {
            self.storeImageView.image = UIImage(named: "user.png")
        }
        
        if let isOfficial = vendor?.official {
            self.officialBadgeImage.isHidden = isOfficial ? false : true
        }
    }
    
}
