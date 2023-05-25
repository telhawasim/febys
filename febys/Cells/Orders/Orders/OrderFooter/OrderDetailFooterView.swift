//
//  OrderDetailFooterView.swift
//  febys
//
//  Created by Faisal Shahzad on 11/10/2021.
//

import UIKit

class OrderDetailFooterView: UITableViewHeaderFooterView {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var orderStatus: FebysLabel!
    @IBOutlet weak var orderAmount: FebysLabel!
    @IBOutlet weak var trackingCode: FebysLabel!
    @IBOutlet weak var shippingImage: UIImageView!
    @IBOutlet weak var actionButtonsView: UIView!
    @IBOutlet weak var trackingDetailStack: UIStackView!
    @IBOutlet weak var priceDetailStack: UIStackView!
    @IBOutlet weak var shippingDetailStack: UIView!
    @IBOutlet weak var cancelDetailView: UIView!
    @IBOutlet weak var cancelReasonLabel: FebysLabel!
    @IBOutlet weak var addReviewButton: FebysButton!
    @IBOutlet weak var returnItemButton: FebysButton!

    
    //MARK: Helpers
    func configureOrderStatus(with status: OrderStatus) {
        switch status {
        case .PENDING:
            self.orderStatus.backgroundColor = .statusPending()
            self.orderStatus.text = getRefinedText(status)
            self.didHide(view: actionButtonsView, true)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, false)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, true)

        case .ACCEPTED:
            self.orderStatus.backgroundColor = .statusProcessing()
            self.orderStatus.text = "Processing"
            self.didHide(view: actionButtonsView, true)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, false)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, true)

        case .CANCELLED_BY_VENDOR:
            self.orderStatus.backgroundColor = .statusCanceledByVendor()
            self.orderStatus.text = getRefinedText(status)
            self.didHide(view: actionButtonsView, true)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, true)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, false)

        case .SHIPPED:
            self.orderStatus.backgroundColor = .statusShipped()
            self.orderStatus.text = getRefinedText(status)
            self.didHide(view: actionButtonsView, true)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, false)
            self.didHide(view: shippingDetailStack, false)
            self.didHide(view: cancelDetailView, true)

        case .CANCELED:
            self.orderStatus.backgroundColor = .statusCanceled()
            self.orderStatus.text = getRefinedText(status)
            self.didHide(view: actionButtonsView, true)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, true)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, false)

        case .REJECTED:
            self.orderStatus.backgroundColor = .statusRejected()
            self.orderStatus.text = getRefinedText(status)
            self.didHide(view: actionButtonsView, true)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, true)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, false)

        case .RETURNED:
            self.orderStatus.backgroundColor = .statusReturn()
            self.orderStatus.text = getRefinedText(status)
            self.didHide(view: actionButtonsView, false)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, false)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, true)

        case .DELIVERED:
            self.orderStatus.backgroundColor = .febysLightGreen()
            self.orderStatus.text = "Received"
            self.didHide(view: actionButtonsView, false)
            self.didHide(view: trackingDetailStack, true)
            self.didHide(view: priceDetailStack, false)
            self.didHide(view: shippingDetailStack, true)
            self.didHide(view: cancelDetailView, true)

        default:
            break
        }
    }
    
    func didHide(view v: UIView, _ isHidden: Bool) {
        v.isHidden = isHidden ? true : false
    }

    func getRefinedText(_ status: OrderStatus) -> String {
        var status = status.rawValue
        status = status.replacingOccurrences(of: "_", with: " ")
        return status.capitalized.trim()
    }
    
    //MARK: Configure
    func configure(_ vendor: VendorProducts?, isRefundable: Bool) {
        let status = OrderStatus(rawValue: vendor?.status ?? "")
        self.configureOrderStatus(with: status ?? .PENDING)
        
        if status == .DELIVERED {
            if (vendor?.hasReviewed ?? false) && !isRefundable {
                (self.didHide(view: actionButtonsView, true))
            }
        }
        
        self.didHide(view: returnItemButton, isRefundable ? false : true)
        if let hasReviewed = vendor?.hasReviewed {
            self.didHide(view: addReviewButton, hasReviewed ? true : false)
        }
        
        self.returnItemButton.isEnabled = false
        _ = vendor?.products?.compactMap({ product in
            if product.isSelected {
                self.returnItemButton.isEnabled = true
            }
        })
        
        self.trackingCode.text = vendor?.courier?.trackingId ?? ""
        self.shippingImage.setImage(url: vendor?.courier?.service?.logo ?? "", scaleToFitFrame: true)
        self.orderAmount.text = vendor?.amount?.formattedPrice()
        self.cancelReasonLabel.text = vendor?.revertDetails?.reason ?? ""
        self.mainStackView.layoutIfNeeded()
    }

}
