//
//  VotingRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 05/11/2021.
//

import Foundation
import SwiftUI

extension URI {
    enum Voting: String {
        case upVote = "products/PRODUCT_ID/threads/THREAD_ID/up-vote"
        case downVote = "products/PRODUCT_ID/threads/THREAD_ID/down-vote"
    }
    
    enum Question: String {
        case ask = "products/PRODUCT_ID/ask-question"
    }
}
