//
//  OrderTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 05/10/2021.
//

import UIKit

class OrderProductTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: FebysLabel!
    @IBOutlet weak var skuID: FebysLabel!
    @IBOutlet weak var productQuantity: FebysLabel!
    @IBOutlet weak var productPrice: FebysLabel!
    @IBOutlet weak var originalPrice: FebysLabel!
    @IBOutlet weak var originalPriceStackView: UIStackView!
    @IBOutlet weak var selectProductButton: FebysButton!
    @IBOutlet weak var statusLabel: FebysLabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureReturnStatus(status: OrderStatus) {
        switch status {
        case .RETURNED:
            self.statusLabel.text = status.rawValue.capitalized
            self.statusLabel.textColor = .white
            self.statusLabel.backgroundColor = .febysBlack()
        case .PENDING_RETURN:
            let status = status.rawValue.components(separatedBy: "_")
            self.statusLabel.text = status.first?.capitalized
            self.statusLabel.textColor = .black
            self.statusLabel.backgroundColor = .febysLightGray()
        default:
            break
        }
    }
    
    func didHideRadioButton(_ isHidden: Bool) {
        selectProductButton.isHidden = isHidden ? true: false
        radioButton.isHidden = isHidden ? true: false
    }
    
    func didHideDivider(_ isHidden: Bool) {
        dividerView.backgroundColor = isHidden ? .clear : .febysMildGreyColor()
    }
    
    func didHideStatusLabel(_ isHidden: Bool) {
        statusLabel.isHidden = isHidden ? true : false
    }
    
    func hide(spacer: UIView, isHidden: Bool) {
        spacer.backgroundColor =  isHidden ? .clear : .febysMildGreyColor()
    }
    
    func configure(with products: Products?, isSelectable: Bool, returnDetail: ReturnDetail? = nil) {
        if let items = products {
            let varient = items.product?.variants?.first
            let image = items.product?.variants?.first?.images?.first
            
            if isSelectable {
                self.didHideRadioButton(false)
                self.radioButton.isSelected = items.isSelected
            } else {
                self.didHideRadioButton(true)
            }
            
            if let returnDetail = returnDetail {
                if returnDetail.items?.first?.skuId == products?.product?.variants?.first?.skuId {
                    let status = OrderStatus(rawValue: returnDetail.status?.uppercased() ?? "")
                    self.didHideStatusLabel(false)
                    self.configureReturnStatus(status: status ?? .PENDING_RETURN)
                } else {
                    self.didHideStatusLabel(true)
                }
            } else {
                self.didHideStatusLabel(true)
            }
            
//            (varient?.hasPromotion ?? false)
//            ? (self.originalPriceStackView.isHidden = false)
//            : (self.originalPriceStackView.isHidden = true)

            if let img = image { self.productImage.setImage(url: img) }
            else { self.productImage.image = UIImage(named: "no-image.png") }
            
            self.productName.text = items.product?.name ?? ""
            self.skuID.text = varient?.skuId ?? ""
            self.productQuantity.text = "\(items.qty ?? 0)"
            self.productPrice.text = varient?.price?.formattedPrice()
//            self.originalPrice.text = varient?.originalPrice?.formattedPrice()
//            self.originalPrice.strikeThrough(true)

            self.mainStackView.layoutIfNeeded()
        }
    }
}

enum OrderType {
    case Order
    case Received
    case Review
    case Cancel
    case Return
}
