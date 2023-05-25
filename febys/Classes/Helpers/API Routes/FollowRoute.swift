//
//  FollowRoute.swift
//  febys
//
//  Created by Abdul Kareem on 28/10/2021.
//

import Foundation

extension URI{
    enum FollowRoute: String {
        case followCelebrity = "consumers/follow/ID"
        case unfollowCelebrity = "consumers/un-follow/ID"
        case followingIds = "consumers/following"
    }
}
