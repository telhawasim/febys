//
//  VoucherRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 10/11/2021.
//

import Foundation

extension URI {
    enum Vouchers: String {
        case getVoucher = "vouchers/VOUCHER_CODE"
        case getVouchersList = "vouchers/of-consumer/list"
        case collectVoucher = "vouchers/collect/VOUCHER_CODE"
    }
}
