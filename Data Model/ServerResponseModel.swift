//
//  ServerResponseModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public class Response: Decodable {
    var status: Status?
    var error: CustomError?
}

public class Status: Decodable {
    var code: String
    var description: String
}

/** Get Users **/
public class GetUsersResponse: Response {
    var data: [User]?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([User].self, forKey: .data)
        try super.init(from: decoder)
    }
}
/** Get Users End **/

public class CreateChallengeResponse: Response {
    
}

public class CreateChallengeData {
    var session: String?
}

/** Create User Begin **/
public class CreateUserResponse: Response {
    var data: CreateUserData?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(CreateUserData.self, forKey: .data)
        try super.init(from: decoder)
    }
}

public class CreateUserData: Decodable {
    var session: String?
    var user: User?
}
/** Create User End **/
