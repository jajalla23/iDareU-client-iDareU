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
        user.id = "00000"
        user.jans?.available = 1000
        
        let challenge1: Challenge = Challenge.init(sponsorId: user.id!, title: "Challenge1", description: "Completed Challenge", reward: 10)
        let challenge2: Challenge = Challenge.init(sponsorId: user.id!, title: "Challenge2", description: "Pending Challenge", reward: 20)
        let challenge3: Challenge = Challenge.init(sponsorId: user.id!, title: "Challenge3", description: "Owned Challenge", reward: 30)
        let challenge4: Challenge = Challenge.init(sponsorId: user.id!, title: "Challenge4", description: "Pending Challenge", reward: 20)
        
        challenge3.description = "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis."
        
        user.addToChallengesCompleted(challenge: challenge1)
        user.addToChallengesPending(challenge: challenge2)
        user.addToChallengesSponsored(challenge: challenge3)
        user.addToChallengesPending(challenge: challenge4)
        user.addToChallengesSponsored(challenge: challenge3)
        
        user.addToChallengesPending(challenge: challenge1)
        user.addToChallengesPending(challenge: challenge2)
        user.addToChallengesPending(challenge: challenge3)
        user.addToChallengesPending(challenge: challenge4)



        let friend1: User = User.init(username: "friend1", password: "pass", email: "friend1@email.com")
        let friend2: User = User.init(username: "friend2", password: "pass", email: "friend1@email.com")
        let friend3: User = User.init(username: "friend3", password: "pass", email: "friend1@email.com")

        user.addFriends(friends: [friend1, friend2, friend3])
        
        return user
    }
}

