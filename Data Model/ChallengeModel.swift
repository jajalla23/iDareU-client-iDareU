//
//  ChallengeModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public class Challenge: Codable {
    public var id: String?
    public var sponsor: Sponsor
    public var title: String
    public var description: String?
    private(set) var reward: Decimal
    public var media: Media?
    private(set) var takers: [Taker]?
    public var location: String?
    private(set) var coSponsors: [Sponsor]?
    
    init(sponsorId: String, title: String, description: String?, reward: Decimal) {
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
    
    public func addCosponsor(user: User, reward: Decimal) {
        let newCosponsor: Sponsor = Sponsor.init(sponsorId: user.id!, reward: reward)
        
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
    public var reward: Decimal
    
    init(sponsorId: String, reward: Decimal) {
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
