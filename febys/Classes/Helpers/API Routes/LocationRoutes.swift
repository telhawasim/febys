//
//  LocationRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 16/11/2021.
//

import Foundation
import SwiftUI

extension URI {
    enum Location: String {
        case countries = "consumers/countries/list"
        case states = "consumers/states-of-country/list"
        case cities = "consumers/cities-of-state/list"
    }
}
