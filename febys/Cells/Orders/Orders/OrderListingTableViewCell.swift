//
//  OrdersTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 01/10/2021.
//

import UIKit

class OrderListingTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var orderIDLabel: FebysLabel!
    @IBOutlet weak var orderDateAndTimeLabel: FebysLabel!
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Helpers
    func configure(_ order: Order?) {
        let date = Date.getFormattedDate(string: order?.createdAt ?? "", format: Constants.dateFormatDD_MMM_yyyy)
        let time = Date.getFormattedDate(string: order?.createdAt ?? "", format: Constants.timeFormatHHmmA)
        
        orderIDLabel.text = order?.orderId ?? ""
        orderDateAndTimeLabel.text = "\(date) \(time)"
    }
}
