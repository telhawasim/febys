//
//  OrderDetailHeaderView.swift
//  febys
//
//  Created by Faisal Shahzad on 07/10/2021.
//

import UIKit

class OrderDetailHeaderView: UITableViewHeaderFooterView {

    //MARK: IBOutlet
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderCancelView: UIView!
    @IBOutlet weak var orderIDLabel: FebysLabel!
    @IBOutlet weak var orderCancelTimeLabel: FebysLabel!
    @IBOutlet weak var orderDateAndTimeLabel: FebysLabel!
    
    //MARK: Properties
    var order: Order?
    var isCancelable: Bool?
    var timer: Timer?
    var totalTime = 60
    
    //MARK: Helpers
    func hideOrderCancelView(_ isHidden: Bool) {
        if isHidden { self.orderCancelView.isHidden = true }
        else { self.orderCancelView.isHidden = false }
    }
    
    private func startCancelTimer(interval: Int) {
        self.totalTime = interval
        if !(self.timer?.isValid ?? false) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTimer() {
        self.orderCancelTimeLabel.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.hideOrderCancelView(true)
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func configure(_ order: Order?) {
        if let order = order {
            self.order = order
            
            self.orderIDLabel.text = order.orderId ?? ""
            if order.isOrderCancelable() {
                let orderDate = order.convertDateIntoLocal()
                let currentDate = order.getCurrenDateMinus(interval: 1800.0)
                let remaningSeconds = orderDate.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate

                self.startCancelTimer(interval: Int(remaningSeconds))
                self.hideOrderCancelView(false)
            } else {
                self.hideOrderCancelView(true)
            }
            
            if let dateString = self.order?.createdAt {
                let date = Date.getFormattedDate(string: dateString, format: Constants.dateFormatDD_MMM_yyyy)
                let time = Date.getFormattedDate(string: dateString, format: Constants.timeFormatHHmmA)
                orderDateAndTimeLabel.text = "\(date) \(time)"
            }
        }
    }
}
