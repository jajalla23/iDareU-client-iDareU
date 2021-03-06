//
//  ChallengeModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public class Challenge: Codable {
    public var sponsored: [ChallengeDetails]?
    public var pending: [ChallengeDetails]?
    public var completed: [ChallengeDetails]?
    public var cosponsored: [ChallengeDetails]?
    
    init() {
        self.sponsored = []
        self.pending = []
        self.completed = []
        self.cosponsored = []
    }
    
    public func addSponsoredChallenge(challengeDetail: ChallengeDetails) {
        if (self.sponsored == nil) {
            self.sponsored = []
        }
        self.sponsored?.append(challengeDetail)
    }
    
    public func addSponsoredChallenge(challengesDetail: [ChallengeDetails]) {
        if (self.sponsored == nil) {
            self.sponsored = []
        }
        self.sponsored?.append(contentsOf: challengesDetail)
    }
    
    public func addPendingChallenge(challengeDetail: ChallengeDetails) {
        if (self.pending == nil) {
            self.pending = []
        }
        self.pending?.append(challengeDetail)
    }
    
    public func addPendingChallenge(challengesDetail: [ChallengeDetails]) {
        if (self.pending == nil) {
            self.pending = []
        }
        self.pending?.append(contentsOf: challengesDetail)
    }
    
    public func addCompletedChallenge(challengeDetail: ChallengeDetails) {
        if (self.completed == nil) {
            self.completed = []
        }
        self.completed?.append(challengeDetail)
    }
    
    public func addCompletedChallenge(challengesDetail: [ChallengeDetails]) {
        if (self.completed == nil) {
            self.completed = []
        }
        self.completed?.append(contentsOf: challengesDetail)
    }
    
    public func addCosponsoredChallenge(challengeDetail: ChallengeDetails) {
        if (self.cosponsored == nil) {
            self.cosponsored = []
        }
        self.cosponsored?.append(challengeDetail)
    }
    
    public func addCosponsoredChallenge(challengesDetail: [ChallengeDetails]) {
        if (self.cosponsored == nil) {
            self.cosponsored = []
        }
        self.cosponsored?.append(contentsOf: challengesDetail)
    }
}

public class ChallengeDetails: Codable {
    public var _id: String?
    private(set) var sponsor: Sponsor?
    public var title: String
    public var description: String?
    private(set) var reward: Int
    public var isPrivate: Bool = false

    public var media: Media?
    public var expiration: Date?
    private(set) var takers: [Taker]?
    private(set) var coSponsors: [String: Sponsor]?
    
    public var isForCommunity: Bool = false
    public var location: String?
    public var createdTimestamp: String?
    
    init(sponsorId: String, sponsor_displayName: String, title: String, description: String?, reward: Int) {
        self.sponsor = Sponsor.init(sponsorId: sponsorId, display_name: sponsor_displayName, reward: reward)
        self.title = title
        self.description = description
        self.reward = reward
    }
       
    public func addSponsor(user: User, reward: Int) {
        self.sponsor = Sponsor.init(sponsorId: user._id!, display_name: (user.display_name ?? "<no display name>"), reward: reward)
        self.reward += reward
    }
    
    public func updateSponsorReward(reward: Int) {
        let new_reward = (self.reward - self.sponsor!.reward) + reward
        self.sponsor!.reward = reward
        self.reward = new_reward
    }
    
    public func addMedia(fileName: String, type: String, imagePrevURL: String?) {
        if (self.media == nil) {
            self.media = Media.init(fileName: fileName, type: type)
        } else {
            self.media?.fileName = fileName
        }
        
        self.media?.preview = imagePrevURL
    }
    
    public func addTaker(user: User) {
        if (self.takers == nil) {
            self.takers = []
        }
        
        let taker: Taker = Taker.init(user: user)
        self.takers?.append(taker)
    }
    
    public func replaceTaker(newTaker: Taker) {
        let temp = self.takers?.filter({$0.user._id != newTaker.user._id})
        self.takers = temp
        self.takers?.append(newTaker)
    }
    
    public func removeAllTakers() {
        self.takers?.removeAll()
    }
    
    public func addCosponsor(user: User, reward: Int) {
        let newCosponsor: Sponsor = Sponsor.init(sponsorId: user._id!, display_name: (user.display_name ?? "<no display name>"), reward: reward)
        
        // if condition ? true : else
        if (self.coSponsors == nil) {
            self.coSponsors = [String: Sponsor]()
        }
        
        self.coSponsors?[newCosponsor._id] = newCosponsor
        self.reward += reward
    }
    
    public func removeCosponsor(sponsorId: String) -> Bool {
        return self.coSponsors!.removeValue(forKey: sponsorId) != nil
    }
}

public class Taker: Codable {
    public var user: User
    public var completed: Bool?
    public var completedTimestamp: String?
    public var accepted: Bool?
    public var acceptedTimestamp: String?
    public var responseStatus: ResponseStatus?
    public var media: Media?
    
    
    @available(*, deprecated, message: "to be removed")
    public var isCompleted: Bool?
    
    @available(*, deprecated, message: "to be removed")
    public var responseAccepted: Bool?

    @available(*, deprecated, message: "to be removed")
    public var responseAcceptedTimestamp: Date?
    
    init(user: User) {
        self.user = user
        self.completed = false
        self.accepted = false
        self.responseStatus = ResponseStatus.init()
    }
    
    public func addMedia(fileName: String, type: String, imagePrevURL: String?) {
        if (self.media == nil) {
            self.media = Media.init(fileName: fileName, type: type)
        } else {
            self.media?.fileName = fileName
        }
        
        self.media?.preview = imagePrevURL
    }
}

public class Sponsor: Codable {
    public var _id: String
    public var display_name: String
    public var reward: Int
    
    init(sponsorId: String, display_name: String, reward: Int) {
        self._id = sponsorId
        self.display_name = display_name
        self.reward = reward
    }
}

public class Media: Codable {
    public var preview: String?
    public var fileName: String
    public var type: String
    
    init(fileName: String, type: String) {
        self.fileName = fileName
        self.type = type
    }
}

public class ResponseStatus: Codable {
    public var accepted: Bool?
    public var accept_timestamp: String?
    public var rejected: Bool?
    public var reject_timestamp: String?
    
    init() {
        self.accepted = false
        self.rejected = false
    }
}
