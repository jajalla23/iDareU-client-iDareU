//
//  ErrorModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/28/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

class CustomError: Codable, Error {
    var code: String
    var description: String
    var severity: Severity?
    var location: String?
    
    init(code: String, description: String, severity: Severity, location: String) {
        self.code = code
        self.description = description
        self.severity = severity
        self.location = location
    }
    
    enum CodingKeys : String, CodingKey {
        case code = "code"
        case description = "description"
        case severity = "severity"
        case location = "location"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        description = try container.decode(String.self, forKey: .description)
        severity = try container.decode(Severity.self, forKey: .severity)
        location = try container.decode(String.self, forKey: .location)
    }
}

enum Severity: String, Codable {
    case HIGH
    case MEDIUM
    case LOW
}
