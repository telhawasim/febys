//
//  TransactionHistoryTableViewCell.swift
//  febys
//
//  Created by Nouman Akram on 12/01/2022.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {

    //MARK: Outlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var transactionIdLabel: FebysLabel!
    @IBOutlet weak var amountLabel: FebysLabel!
    @IBOutlet weak var dateAndTimeLabel: FebysLabel!
    @IBOutlet weak var sourceLabel: FebysLabel!
    @IBOutlet weak var statusLabel: FebysLabel!
    @IBOutlet weak var purposeLabel: FebysLabel!
    //MARK: Variables
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.cornerRadius = 6.0
    }
    
    func getStatusColor(status: String) -> UIColor {
        switch status {
        case "CLAIMED":
            return UIColor.statusClaimed()
        case "REJECTED":
            return UIColor.statusRejected()
        case "REVERSAL_CLAIMED":
            return UIColor.statusRevarsal()
        case "REFUND":
            return UIColor.statusRevarsal()
        default:
            return UIColor.statusClaimed()
        }
    }
    
    //MARK: Configure Data
    func configure(_ item: Transaction?){
        var price = Price()
        price.currency = item?.billingCurrency
        price.value = item?.billingAmount
        
        let status =  item?.status?.components(separatedBy: "_")
        self.transactionIdLabel.text = item?.id
        self.amountLabel.text = price.formattedPrice()
        self.purposeLabel.text = item?.purpose?.replacingOccurrences(of: "_", with: " ").capitalized
        let source = item?.source?.replacingOccurrences(of: "_", with: " ").capitalized
        self.sourceLabel.text = (source == "Paystack") ? "Momo Payment" : source
        self.statusLabel.text = status?.first?.capitalized
        self.statusLabel.backgroundColor = getStatusColor(status: item?.status ?? "")

        let date = Date.getFormattedDate(string: item?.createdAt ?? "", format: Constants.dateFormatDD_MMM_yyyy)
        let time = Date.getFormattedDate(string: item?.createdAt ?? "", format: Constants.timeFormatHHmmA)
        dateAndTimeLabel.text = "\(date) \(time)"
    }
}
