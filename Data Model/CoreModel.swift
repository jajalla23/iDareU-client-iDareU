//
//  CoreDataModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/25/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit

public class Jan: Codable {
    public var total: Decimal
    public var available: Decimal
    public var committed: Decimal
    
    init() {
        self.total = 99
        self.available = 99
        self.committed = 0
    }
}

public class User: Codable {
    public var id: String?
    public var username: String? = ""
    public var password: String? = ""
    public var email: String? = ""
    public var jans: Jan?
    public var friends: [User]?
    public var challengesSponsored: [Challenge]?
    public var challengesCompleted: [Challenge]?
    public var challengesPending: [Challenge]?
    public var challengesCosponsored: [Challenge]?
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
        
        self.jans = Jan()
        self.friends = []
        self.challengesSponsored = []
        self.challengesCompleted = []
        self.challengesPending = []
        self.challengesCosponsored = []
    }
    
    public func addFriends(friends: [User]) {
        self.friends?.append(contentsOf: friends)
    }
    
    public func addFriend(friend: User) {
        self.friends?.append(friend)
    }
    
    public func addToChallengesSponsored(challenges: [Challenge]) {
        self.challengesSponsored?.append(contentsOf: challenges)
    }
    
    public func addToChallengesSponsored(challenge: Challenge) {
        self.challengesSponsored?.append(challenge)
    }
    
    public func addToChallengesCompleted(challenges: [Challenge]) {
        self.challengesCompleted?.append(contentsOf: challenges)
    }
    
    public func addToChallengesCompleted(challenge: Challenge) {
        self.challengesCompleted?.append(challenge)
    }
    
    public func addToChallengesPending(challenges: [Challenge]) {
        self.challengesPending?.append(contentsOf: challenges)
    }
    
    public func addToChallengesPending(challenge: Challenge) {
        self.challengesPending?.append(challenge)
    }
}
