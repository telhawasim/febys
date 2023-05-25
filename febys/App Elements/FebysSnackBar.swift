//
//  FebysSnackBar.swift
//  febys
//
//  Created by Faisal Shahzad on 18/03/2022.
//

import Foundation

class FebysSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.padding = 20
        style.actionTextColorAlpha = 1
        style.actionFont = .helvetica(type: .bold, size: 14)
        style.actionTextColor = .white
        style.background = .febysBlack()
        style.textColor = .white
        style.font = .helvetica(type: .medium, size: 14)
        return style
    }
}
