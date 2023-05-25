//
//  ShippingAddressTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 20/09/2021.
//

import UIKit

class ShippingAddressTableViewCell: UITableViewCell {
    //MARK: IBOUTLET
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressDefaultLabel: FebysLabel!
    @IBOutlet weak var addressTagLabel: FebysLabel!
    @IBOutlet weak var addressLabel: FebysLabel!
    @IBOutlet weak var postalCodeLabel: FebysLabel!
    @IBOutlet weak var countryLabel: FebysLabel!
    @IBOutlet weak var radioImageButton: FebysButton!
    @IBOutlet weak var editButton: FebysButton!
    @IBOutlet weak var deleteButton: FebysButton!
    
    
    //MARK: PROPERTIES
    var selectedAddress: ShippingDetails?
    
    //MARK: CONFIGURE
    func configure(_ detail: ShippingDetails?, isSelected: Bool) {
        let address = detail?.shippingDetail?.address

        setCellSelection(isSelected)
        addressDefaultLabel.isHidden = !(detail?.shippingDetail?.isDefault ?? false)
        nameLabel.text = detail?.shippingDetail?.firstName?.capitalized ?? ""
        addressTagLabel.text = detail?.shippingDetail?.label?.capitalized ?? ""
        addressLabel.text = generateAddressString(address: address)
        postalCodeLabel.text = generatePostalString(address: address)
        countryLabel.text = address?.countryCode?.capitalized ?? ""
    }
    
    //MARK: HELPERS
    func setCellSelection(_ selected: Bool) {
        radioImageButton.isSelected = selected
    }
    
    func generateAddressString(address: Address?) -> String {
        var addressString = ""
        if let street = address?.street {
            addressString += "\(street)"
        }
        if let city = address?.city {
            addressString += ", \(city)"
        }
        if let state = address?.state {
            if let zipCode = address?.zipCode, !zipCode.isEmpty {
                addressString += ", \(state)"
            }
        }
        
        if !addressString.isEmpty {
            addressString += "."
        }
        
        return addressString
    }
    
    func generatePostalString(address: Address?) -> String {
        var addressString = ""
        if let zipCode = address?.zipCode, !zipCode.isEmpty {
            addressString += "\(zipCode),"
        } else if let state = address?.state, !state.isEmpty {
            addressString += "\(state),"
        }
        return addressString
    }
}
