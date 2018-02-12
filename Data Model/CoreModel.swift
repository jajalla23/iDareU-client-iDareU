//
//  CoreDataModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/25/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit

public class User: Codable {
    public var _id: String?
    public var email: String?

    //public var username: String?
    //public var password: String?
    //public var facebook_id: String?
    //public var google_id: String?
    
    public var identification: Identification?
    
    public var jans: Jan?
    private(set) var friends: [String: User]?
    private(set) var challenges: Challenge?
    
    init(facebook_id: String, email: String) {
        self.email = email
        
        self.identification = Identification()
        self.identification?.facebook_id = facebook_id
        
        self.jans = Jan()
        self.friends = [String: User]()
        self.challenges = Challenge()
    }
    
    init(username: String, password: String, email: String) {
        self.email = email
        self.identification = Identification()
        self.identification!.username = username
        self.identification!.password = password
        
        self.jans = Jan()
        self.friends = [String: User]()
        self.challenges = Challenge()
    }
    
    public func addFriends(friends: [User]) {
        //self.friends?.append(contentsOf: friends)
        for friend in friends {
            self.addFriend(friend: friend)
        }
    }
    
    public func addFriend(friend: User) {
        self.friends![friend._id!] = friend
    }
    
    public func addSponsoredChallenges(challengesDetail: [ChallengeDetails]) {
        self.challenges?.addSponsoredChallenge(challengesDetail: challengesDetail)
    }
    
    public func addSponsoredChallenges(challengeDetail: ChallengeDetails) {
        self.challenges?.addSponsoredChallenge(challengeDetail: challengeDetail)
    }
    
    public func addPendingChallenges(challengesDetail: [ChallengeDetails]) {
        self.challenges?.addPendingChallenge(challengesDetail: challengesDetail)
    }
    
    public func addPendingChallenges(challengeDetail: ChallengeDetails) {
        self.challenges?.addPendingChallenge(challengeDetail: challengeDetail)
    }
    
    public func addCompletedChallenges(challengesDetail: [ChallengeDetails]) {
        self.challenges?.addCompletedChallenge(challengesDetail: challengesDetail)
    }
    
    public func addCompletedChallenges(challengeDetail: ChallengeDetails) {
        self.challenges?.addCompletedChallenge(challengeDetail: challengeDetail)
    }
    
    public func addToCosponsoredChallenges(challengesDetail: [ChallengeDetails]) {
        self.challenges?.addCosponsoredChallenge(challengesDetail: challengesDetail)
    }
    
    public func addToCosponsoredChallenges(challengeDetail: ChallengeDetails) {
        self.challenges?.addCompletedChallenge(challengeDetail: challengeDetail)
    }
}

public class Jan: Codable {
    public var total: Int
    public var available: Int
    public var committed: Int
    
    init() {
        self.total = 99
        self.available = 99
        self.committed = 0
    }
}

public class Identification: Codable {
    public var username: String?
    public var password: String?
    public var facebook_id: String?
    public var google_id: String?
}
