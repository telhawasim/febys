//
//  OrderRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 31/10/2021.
//

import Foundation

extension URI {
    enum Order: String {
        case orderInfo = "orders/info"
        case placeOrder = "orders"
        case orderList = "orders/for-consumer/list"
        case orderById = "orders/for-consumer/ID"
        case cancelOrder = "orders/ORDER_ID/vendor/VENDOR_ID/cancel"
        case cancelReasons = "order-settings/consumer/order/cancellation/reasons"
        case returnOrder = "orders/ORDER_ID/pending_return"
        case returnReasons = "order-settings/consumer/order/consumerReturnReasons"
    }
}
