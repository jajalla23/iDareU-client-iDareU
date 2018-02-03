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
    public var sponsor: Sponsor
    public var title: String
    public var description: String?
    private(set) var reward: Int
    public var media: Media?
    private(set) var takers: [Taker]?
    public var location: String?
    private(set) var coSponsors: [Sponsor]?
    
    init(sponsorId: String, title: String, description: String?, reward: Int) {
        self.sponsor = Sponsor.init(sponsorId: sponsorId, reward: reward)
        self.title = title
        self.description = description
        self.reward = reward
    }
    
    public func addMedia(challengeVideoURL: String, imagePrevURL: String?) {
        self.media?.challengeVideoURL = challengeVideoURL
        self.media?.challengeImagePreviewURL = imagePrevURL
    }
    
    public func addTaker(user: User) {
        let taker: Taker = Taker.init(user: user)
        self.takers?.append(taker)
    }
    
    public func removeAllTakers() {
        self.takers?.removeAll()
    }
    
    public func addCosponsor(user: User, reward: Int) {
        let newCosponsor: Sponsor = Sponsor.init(sponsorId: user._id!, reward: reward)
        
        // if condition ? true : else
        if (self.coSponsors == nil) {
            self.coSponsors = []
        }
        
        self.coSponsors?.append(newCosponsor)
        self.reward += reward
    }
    
    public func removeCosponsor(sponsorId: String) -> Bool {
        if let i = self.coSponsors!.index(where: { $0.id == sponsorId }) {
            self.coSponsors?.remove(at: i)
            return true
        }
    
        return false
    }
}

public class Taker: Codable {
    public var user: User
    public var isCompleted: Bool
    public var completedTimestamp: Date?
    public var responseAccepted: Bool
    public var responseAcceptedTimestamp: Date?
    
    init(user: User) {
        self.user = user
        self.isCompleted = false
        self.responseAccepted = false
    }
}

public class Sponsor: Codable {
    public var id: String
    public var reward: Int
    
    init(sponsorId: String, reward: Int) {
        self.id = sponsorId
        self.reward = reward
    }
}

public class Media: Codable {
    public var challengeImagePreviewURL: String?
    public var challengeVideoURL: String
    
    init(challengeVideoURL: String) {
        self.challengeVideoURL = challengeVideoURL
    }
}
