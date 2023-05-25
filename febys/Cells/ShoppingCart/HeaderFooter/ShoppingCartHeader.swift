//
//  ShoppingCartHeader.swift
//  febys
//
//  Created by Ab Saqib on 17/08/2021.
//

import UIKit
class ShoppingCartHeader: UITableViewHeaderFooterView {
    
    //MARK: IBOutlet
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: FebysLabel!
    @IBOutlet weak var headerRole: FebysLabel!
    @IBOutlet weak var cancelButton: FebysButton!
    @IBOutlet weak var vendorDetailButton: FebysButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingPadding: NSLayoutConstraint!
    @IBOutlet weak var trailingPadding: NSLayoutConstraint!

    //MARK: Properties
    var vendorId: String?
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Helpers
    func configureCancelableHeader(with status: OrderStatus) {
        switch status {
        case .PENDING, .ACCEPTED:
            self.hideCancelButton(false)
        default:
            self.hideCancelButton(true)
        }
    }
    
    func configure(with vendor: Vendor? = nil, forCart: Bool, status: String? = "", isCancelable: Bool = false) {

        if isCancelable {
            if let status = OrderStatus(rawValue: status ?? "") {
                self.configureCancelableHeader(with: status)
            }
        } else {
            self.hideCancelButton(true)
        }
        
        if forCart {
            leadingConstraint.constant = 32.0
            trailingConstraint.constant = 32.0
        } else {
            leadingConstraint.constant = 10.0
            trailingConstraint.constant = 10.0
        }
        
        if let item = vendor {
            self.vendorId = item.id
            self.headerTitle.text = item.shopName ?? ""
            self.headerRole.text = item.role?.name ?? ""
            if let url = item.businessInfo?.logo {
                self.headerImage.setImage(url: url)
            } else { self.headerImage.image = UIImage(named: "user.png") }
        }
    }

    func hideCancelButton(_ isHidden: Bool) {
        if isHidden { cancelButton.isHidden = true }
        else { cancelButton.isHidden = false }
    }
}


