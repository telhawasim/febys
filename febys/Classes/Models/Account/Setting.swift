//
//  Setting.swift
//  febys
//
//  Created by Faisal Shahzad on 08/09/2021.
//

import UIKit

struct Setting {
    let isToggle : Bool?
    let title : String?
    let image : UIImage?
    let showWithoutLogin: Bool
    
    init(isToggle: Bool? = false,
         title: String?,
         image: UIImage? = nil,
         showWithoutLogin: Bool = false)
    {
        self.isToggle = isToggle
        self.title = title
        self.image = image
        self.showWithoutLogin = showWithoutLogin
    }
}
