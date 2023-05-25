//
//  ReviewsTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 27/12/2021.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: FebysLabel!
    @IBOutlet weak var productSkuId: FebysLabel!

    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func didHideDivider(_ isHidden: Bool) {
        isHidden
        ? (self.dividerView.backgroundColor = .clear)
        : (self.dividerView.backgroundColor = .febysMildGreyColor())
    }
    
    //MARK: Configure
    func configure(_ products: Products?) {
        if let url = products?.product?.variants?.first?.images?.first {
            self.productImage.setImage(url: url)
        } else {
            self.productImage.image = UIImage(named: "no-image")
        }
        
        let skuId = products?.product?.variants?.first?.skuId
        self.productSkuId.text = skuId ?? ""
        self.productName.text = products?.product?.name ?? ""
        
        self.mainStackView.layoutIfNeeded()
    }
    
}
