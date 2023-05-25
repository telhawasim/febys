//
//  PaymentTableViewCell.swift
//  febys
//
//  Created by Abdul Kareem on 06/10/2021.
//

import UIKit


struct AttributedString {
    let string: String!
    let font: UIFont!
    let color: UIColor!
}

class PaymentTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentNameLabel: FebysLabel!
    @IBOutlet weak var paymentAmountLabel: FebysLabel!
    @IBOutlet weak var paymentFeeLabel: FebysLabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    //MARK: Properties
    var isWalletDisabled = false
    
    
    
    //MARK: Helpers
    func setState(isSelected: Bool) {
        selectedImageView.isHidden = !isSelected
        mainView.borderColor = isSelected ? .febysRed() : .febysMildGreyColor()
    }
    
    func setAvaliability(isEnable: Bool, amounts: [AttributedString?], fees: [AttributedString?]) {
        paymentNameLabel.textColor = isEnable ? .black : .febysDisableGrey()
        
        if !amounts.isEmpty {
            var attributedAmount = NSAttributedString()
            if let attrString = amounts.first, let first = attrString {
                attributedAmount = attributedText(
                    string: first.string,
                    color: isEnable ? first.color : .febysDisableDarkGrey(),
                    font: first.font)
            }
            
            if let attrString = amounts.last, let last = attrString {
                attributedAmount = attributedAmount + attributedText(
                    string: last.string,
                    color: isEnable ? last.color : .febysDisableGrey(),
                    font: last.font)
            }
            
            paymentAmountLabel.attributedText = attributedAmount
        }
        
        if !fees.isEmpty {
            var attributedFee = NSAttributedString()
            if let attrString = fees.first, let first = attrString {
                attributedFee = attributedText(
                    string: first.string,
                    color: isEnable ? first.color : .febysDisableGrey(),
                    font: first.font)
            }
            
            if let attrString = fees.last, let last = attrString {
                attributedFee = attributedFee + attributedText(
                    string: last.string,
                    color: isEnable ? last.color : .febysDisableGrey(),
                    font: last.font)
            }
            
            paymentFeeLabel.attributedText = attributedFee
        }
        
        paymentImageView.image?.withRenderingMode(isEnable ?
            .alwaysOriginal : .alwaysTemplate)
        paymentImageView.tintColor = isEnable ? .febysRed() : .febysDisableGrey()
    }
    
    func attributedText(string: String, color: UIColor, font: UIFont) -> NSAttributedString {
        
        let attributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes:attributes as [NSAttributedString.Key : Any])
        
        return attributedString
    }
    
    func isWalletAvaliable() -> Bool {
        guard let wallet = UserInfo.fetch()?.wallet else { return  false}
        
        if ((wallet.currency == nil) || ((wallet.availableBalance ?? 0.0) <= 0.0))
        { return false }
        else { return true }
    }
    
    func generateFeeSlat(slab: Slab) -> String {
        var feeString = ""
        if(slab.type == "PERCENTAGE") {
            feeString = "\(slab.percentage?.clean ?? "0")%"
        }else if(slab.type == "FIXED") {
            feeString = "\(slab.currency ?? "$")\(slab.fixed?.currencyFormattedString() ?? "0.00")"
        }else if(slab.type == "BOTH") {
            feeString = "\(slab.percentage?.clean ?? "0")% + \(slab.currency ?? "$")\(slab.fixed?.currencyFormattedString() ?? "0.00")"
        }
        return feeString
    }
    
    func didHideAmountLabel(_ isHidden: Bool) {
        paymentAmountLabel.isHidden = isHidden
    }
    
    func didHideFeeLabel(_ isHidden: Bool) {
        paymentFeeLabel.isHidden = isHidden
    }
    
    //MARK: Configure
    func configureWallet(isSplited: Bool) {
        guard let wallet = UserInfo.fetch()?.wallet else {return}

        var walletBalance = Price()
        walletBalance.value = wallet.convertedBalance
        walletBalance.currency = wallet.convertedCurrency

        let walletAmount = AttributedString(string: walletBalance.formattedPrice(), font: .arial(type: .bold, size: 16), color: .febysRed())
        let amountStatus = AttributedString(string: isSplited ? " taken" : " avaliable", font: .arial(type: .regular, size: 14), color: .febysBlack())
        
        self.setAvaliability(isEnable: isWalletAvaliable(), amounts: [walletAmount, amountStatus], fees: [])
    }
    
    func configureOtherPayments(title: String?, slab: Slab?) {
        var attributedTitle: AttributedString?
        var attributedSlabFee: AttributedString?
        var attributedSlabText: AttributedString?
        
        if let title = title {
            self.didHideAmountLabel(false)
            attributedTitle = AttributedString(string: title, font: .arial(type: .regular, size: 14), color: .febysBlack())
        } else {
            self.didHideAmountLabel(true)
        }
        
        if let slab = slab {
            self.didHideFeeLabel(false)
            attributedSlabFee = AttributedString(string: generateFeeSlat(slab: slab), font: .arial(type: .bold, size: 14), color: .febysRed())
            
            attributedSlabText = AttributedString(string: " Processing fees will be charged", font: .arial(type: .regular, size: 14), color: .febysGray())
        } else {
            self.didHideFeeLabel(true)
        }
        
        self.setAvaliability(isEnable: true, amounts: [nil, attributedTitle], fees: [attributedSlabFee, attributedSlabText])
    }
    
    func configure(_ paymentMethod: PaymentMethod) {
        
        switch paymentMethod {
        case .WALLET(let isSelected, let isSplited):
            self.isUserInteractionEnabled = (isSplited || !isWalletAvaliable()) ? false : true
            self.setState(isSelected: isSelected)
            self.configureWallet(isSplited: isSplited)
            self.didHideAmountLabel(false)
            self.didHideFeeLabel(true)
            
            paymentNameLabel.text = "Wallet"
            paymentImageView.image = UIImage.init(named: "wallet-icon")?.withRenderingMode(.alwaysTemplate)
            
        case .BRAINTREE(let isSelected, let feeSlab):
            self.isUserInteractionEnabled = true
            self.setState(isSelected: isSelected)
            self.configureOtherPayments(title: "PayPal, Credit or Debit Card", slab: feeSlab)
            
            paymentImageView.image = UIImage.init(named: "paypal-icon")
            paymentNameLabel.text = "Paypal"
            
        case .PAYSTACK(let isSelected, let feeSlab):
            self.isUserInteractionEnabled = true
            self.setState(isSelected: isSelected)
            self.configureOtherPayments(title: "Pay via MOMO or Bank Card", slab: feeSlab)
            
            paymentImageView.image = UIImage.init(named: "paystack-icon")
            paymentNameLabel.text = "MOMO | Bank Card"
        }
    }
}
