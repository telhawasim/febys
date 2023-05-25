//
//  Double.swift
//  febys
//
//  Created by Faisal Shahzad on 18/01/2022.
//

import Foundation
import UIKit

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK:- FORMATTING LARGE NUMBERS
/*
 print(formatNumber(1515)) // 1.5K
 print(formatNumber(999999)) // 999.9K
 print(formatNumber(1000999)) // 1.0M
 */
extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
    
    func formatNumber() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted.currencyFormattedString())B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted.currencyFormattedString())M"

//        case 1_000...:
//            var formatted = num / 1_000
//            formatted = formatted.reduceScale(to: 1)
//            return "\(sign)\(formatted.currencyFormattedString())K"

        case 0...:
            return "\(self.currencyFormattedString())"

        default:
            return "\(sign)\(self)"
        }
    }
    
    func currencyFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        // minimum decimal digit, eg: to display 2 as 2.00
        formatter.minimumFractionDigits = 2

        // maximum decimal digit, eg: to display 2.5021 as 2.50
        formatter.maximumFractionDigits = 2

        // round up 21.586 to 21.59. But doesn't round up 21.582, making it 21.58
//        formatter.roundingMode = .halfUp

        let price = self
        return formatter.string(for: price) ?? ""
    }

}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

}
