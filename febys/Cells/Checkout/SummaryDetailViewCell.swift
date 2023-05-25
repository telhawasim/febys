//
//  SummeryViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 24/08/2022.
//

import UIKit

class SummaryDetailViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var summaryLabel: FebysLabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var vatInclLabel: FebysLabel!
    @IBOutlet weak var totalPriceLabel: FebysLabel!

    
    func updateTotalPrice(_ order: Order?) {
        if var billAmount = order?.billAmount {
           
            if let transactions = order?.transactions?.first(where: { $0.transactionFeeInfo != nil }), let feeInfo = transactions.transactionFeeInfo {
                
                billAmount.value! += feeInfo.value!
            }
            
            if let shippingFee = order?.swooveEstimates?.responses?.selectedEstimate?.totalPricing {
                
                billAmount.value! += shippingFee.value!
            }
            
            self.totalPriceLabel.text = billAmount.formattedPrice()
        }
    }
    
    
    //MARK: CONFIGURE
    func configure(_ order: Order?) {
        stackView.removeAllArrangedSubviews()
       
        if let order = order {
            let items = order.vendorProducts
            let itemCount = self.getItemsCount(of: items)
            let itemString = itemCount == 1 ? "Item" : "Items"
            let currency = order.billAmount?.currency ?? "GHS"
            
            summaryLabel.text = "Order Summary (\(itemCount) \(itemString))"
            updateTotalPrice(order)

            for item in items ?? [] {
                for product in item.products ?? [] {
                    if var productPrice = product.product?.variants?.first?.price {
                        let totalPrice = (productPrice.value ?? 0.0) * Double(product.qty ?? 0)
                        productPrice.value = totalPrice
                        addItem(in: self.stackView, title: "\(product.qty ?? 0) x \(product.product?.name ?? "")", price: productPrice)
                    }
                }
            }
            
//            if let vat = order.vatPercentage,
//               let subtotal = order.productsAmount {
//                var vatAmount = Price()
//                vatAmount.currency = currency
//                if (vat > 0) {
//                    let vatIntoSubtotal = (subtotal.value ?? 0) * Double(vat)
//                    vatAmount.value = vatIntoSubtotal / 100.0
//                }
//
//                addItem(in: self.stackView, title: "VAT (\(Float(vat))%)", price: vatAmount)
//            }
            
            if let subtotal = order.productsAmount {
                let subtotalStr = "Subtotal"
//                if let _ = order.vatPercentage { subtotalStr += " (incl. VAT)" }
                addItem(in: self.stackView, title: subtotalStr, price: subtotal)
            }
            
            if let vat = order.vatPercentage {
                self.vatInclLabel.isHidden = (vat > 0) ? false : true
            }
            
            if let estimate = order.swooveEstimates?.responses?.selectedEstimate ?? order.swoove?.estimate {
                
                var price = Price()
                price.value = estimate.totalPricing?.value ?? Defaults.double
                price.currency = estimate.totalPricing?.currencyCode ?? Defaults.currency
                
                addItem(in: self.stackView, title: "Shipping Fee", price: price)
            }
            
            if let transactions = order.transactions?.first(where: { $0.transactionFeeInfo != nil }), let feeInfo = transactions.transactionFeeInfo {
                
                var processingFee = Price()
                processingFee.currency = feeInfo.currency
                processingFee.value = feeInfo.value
                
                addItem(in: self.stackView, title: "Processing Fee", price: processingFee)
            }
            
            if let voucher = order.voucher {
                var voucherAmount = Price()
                voucherAmount.value = voucher.discount
                voucherAmount.currency = currency
                addItem(in: self.stackView, title: "Voucher Discount", price: voucherAmount, isNegative: true)
            }
            
            self.calculateStackHeight(itemCount: self.stackView.arrangedSubviews.count)

        }
    }
    
    func getContentHeight() -> CGFloat {
        return self.contentView.frame.height
    }
    
    func calculateStackHeight(itemCount: Int) {
        let height: CGFloat = 20.0
        let spacing: CGFloat = 15.0
        let totalHeight = (height + spacing) * CGFloat(itemCount)
        self.stackViewHeight.constant = totalHeight
//        return totalHeight
    }
    
    func getItemsCount(of vendorProducts: [VendorProducts]?) -> Int{
        var count = 0
        for vendors in vendorProducts ?? [] {
            for product in vendors.products ?? [] {
                count += product.qty ?? 0
            }
        }
        return count
    }
    
    private func addItem(in stackView: UIStackView, title: String, price: Price, isNegative: Bool = false) {
        let itemDetailView: SummaryItemView = UIView.fromNib()
        itemDetailView.itemDetailLabel.text = title
        let minusSign = isNegative ? "-" : ""
        itemDetailView.itemPriceLabel.text = minusSign+(price.formattedPrice() ?? "")
        stackView.addArrangedSubview(itemDetailView)
    }
    
}

