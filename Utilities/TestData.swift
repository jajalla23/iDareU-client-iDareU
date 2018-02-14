//
//  TestData.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/28/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

class TestData {
    public static func generateUser() -> User {
        let user: User = User.init(username: "test", password: "test", email: "dummy@email.com")
        user._id = "00000"
        user.jans?.available = 99
        
        let challenge1: ChallengeDetails = ChallengeDetails.init(sponsorId: user._id!, sponsor_displayName: user.identification!.username!, title: "Challenge1", description: "Completed Challenge", reward: 10)
        let challenge2: ChallengeDetails = ChallengeDetails.init(sponsorId: user._id!, sponsor_displayName: user.identification!.username!, title: "Challenge2", description: "Pending Challenge", reward: 20)
        let challenge3: ChallengeDetails = ChallengeDetails.init(sponsorId: user._id!, sponsor_displayName: user.identification!.username!, title: "Challenge3", description: "Owned Challenge", reward: 30)
        let challenge4: ChallengeDetails = ChallengeDetails.init(sponsorId: user._id!, sponsor_displayName: user.identification!.username!, title: "Challenge4", description: "Pending Challenge", reward: 20)
        
        challenge3.description = "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis."
        challenge3.addMedia(fileName: "AD4A76BE-9BC5-4299-804B-6FB317B7D3D1", type: "image/jpg", imagePrevURL: "")
        challenge3._id = "00003"
        
        user.addCompletedChallenges(challengeDetail: challenge1)
        user.addPendingChallenges(challengeDetail: challenge2)
        user.addSponsoredChallenges(challengeDetail: challenge3)
        user.addPendingChallenges(challengeDetail: challenge4)
        user.addSponsoredChallenges(challengeDetail: challenge3)
        
        user.addPendingChallenges(challengeDetail: challenge1)
        user.addPendingChallenges(challengeDetail: challenge2)
        user.addPendingChallenges(challengeDetail: challenge3)
        user.addPendingChallenges(challengeDetail: challenge4)



        let friend1: User = User.init(username: "friend1", password: "pass", email: "friend1@email.com")
        let friend2: User = User.init(username: "friend2", password: "pass", email: "friend1@email.com")
        let friend3: User = User.init(username: "friend3", password: "pass", email: "friend1@email.com")
        let friend4: User = User.init(facebook_id: "12345", email: "facebook@email.com", firstName: "friend4", lastName: "friend")
        friend1._id = "11111"
        friend2._id = "22222"
        friend3._id = "33333"
        friend4._id = "44444"
        
        user.addFriends(friends: [friend1, friend2, friend3, friend4])
        
        return user
    }
    
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

