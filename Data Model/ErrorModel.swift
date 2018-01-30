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
    var severity: String?
    var location: String?
    
    init(code: String, description: String, severity: String, location: String) {
        self.code = code
        self.description = description
        self.severity = severity
        self.location = location
    }
}
