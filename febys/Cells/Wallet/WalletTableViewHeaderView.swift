//
//  WalletTableViewHeaderFooterView.swift
//  febys
//
//  Created by Nouman Akram on 12/01/2022.
//

import UIKit

class WalletTableViewHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var walletBalance: FebysLabel!
    @IBOutlet weak var withdrawButton: FebysButton!
    @IBOutlet weak var topUpButton: FebysButton!

    func configure() {
        let wallet = UserInfo.fetch()?.wallet
        var balance = Price()
        balance.currency = wallet?.currency ?? "GHS"
        balance.value = wallet?.availableBalance?.round(to: 2) ?? 0.0
        walletBalance.text = balance.formattedPrice()
    }

}
