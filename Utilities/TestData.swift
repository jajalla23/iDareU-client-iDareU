//
//  TestData.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/28/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

class TestData {    
    public static func getFriendFeed() -> [FriendFeed] {
        let challenge1: ChallengeFriendFeed = ChallengeFriendFeed(id: "11111", title: "Challenge 1", description: "Challenge 1", reward: 100, url: "", imagePreviewURL: "Play", isCompleted: true)
        let challenge2: ChallengeFriendFeed = ChallengeFriendFeed(id: "22222", title: "Challenge 2", description: "Challenge 2", reward: 50, url: "", imagePreviewURL: "Play", isCompleted: false)
        
        let friendFeed1: FriendFeed = FriendFeed(challenge: challenge1, ownerUsername: "friendA", friendUsername: "friendB")
        let friendFeed2: FriendFeed = FriendFeed(challenge: challenge2, ownerUsername: "friendB", friendUsername: "friendA")
        let friendFeed3: FriendFeed = FriendFeed(challenge: challenge1, ownerUsername: "friendB", friendUsername: "friendA")
        let friendFeed4: FriendFeed = FriendFeed(challenge: challenge2, ownerUsername: "friendA", friendUsername: "friendB")
        
        let friendFeeds: [FriendFeed] = [friendFeed1, friendFeed2, friendFeed3, friendFeed4]
        
        return friendFeeds
    }
}

