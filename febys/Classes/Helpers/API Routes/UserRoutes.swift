//
//  Login.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import Foundation
import SwiftUI

extension URI{
    enum Users: String {
        case info = "consumers/me"
        case login = "consumers/login"
        case socialLogin = "social/login"
        case signUp = "consumers"
        case verifyOTP = "consumers/verify-otp"
        case forgotPassword = "consumers/forgot-password"
        case uploadImage = "media/upload/consumer_profile"
    }
}
