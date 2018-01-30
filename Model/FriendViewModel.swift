//
//  CommunityViewModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/7/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public class FriendFeed2 {
    let friendA : String
    let friendB : String
    let challenge : String
    let type : String
    
    init (friendA : String, friendB : String, challenge : String, type : String) {
        self.friendA = friendA
        self.friendB = friendB
        self.challenge = challenge
        self.type = type
    }
}

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
