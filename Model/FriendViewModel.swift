//
//  CommunityViewModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/7/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public struct FriendFeed {
    let challenge: ChallengeFriendFeed
    
    let ownerUsername : String
    let friendUsername : String
}

public struct ChallengeFriendFeed {
    let id: String
    let title: String
    let description : String
    let reward: Decimal
    let url: String?
    let imagePreviewURL: String?
    let isCompleted: Bool
}
