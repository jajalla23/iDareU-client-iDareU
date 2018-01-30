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
    public var ownerId: String
    public var title: String
    public var description: String?
    public var reward: Decimal
    public var media: Media?
    public var takers: [Taker]?
    public var location: String?
    
    init(ownerId: String, title: String, description: String?, reward: Decimal) {
        self.ownerId = ownerId
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

public class Media: Codable {
    public var challengeImagePreviewURL: String?
    public var challengeVideoURL: String
    
    init(challengeVideoURL: String) {
        self.challengeVideoURL = challengeVideoURL
    }
}
