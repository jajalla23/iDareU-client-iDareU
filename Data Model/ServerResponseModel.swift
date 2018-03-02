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
    var code: String?
    var description: String?
}

public class DefaultData: Decodable {
    var n: String?
    var nModified: Int?
    var ok: Int?
}

/** Default Begin **/
public class DefaultResponse: Response {
    var data: [DefaultData]?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([DefaultData].self, forKey: .data)
        try super.init(from: decoder)
    }
}
/** Default End **/

/** Login Begin **/
public class LoginResponse: Decodable {
    var status: Status?
    var error: CustomError?
    var data: LoginData?
}

public class LoginData: Decodable {
    var session: String?
    var user: User?
}
/** Login End **/

/** Get Other Users **/
public class GetOtherUsersResponse: Response {
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
/** Get Other Users End **/

/** Get Users **/
public class GetUserResponse: Response {
    var data: User?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(User.self, forKey: .data)
        try super.init(from: decoder)
    }
}
/** Get Users End **/

public class CreateChallengeResponse: Response {
    var data: [ChallengeDetails]?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([ChallengeDetails].self, forKey: .data)
        try super.init(from: decoder)
    }
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

/** Add Friends Begin **/
public class AddFriendsResponse: Response {
    var data: [DefaultData]?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([DefaultData].self, forKey: .data)
        try super.init(from: decoder)
    }
}
/** Add Friends End **/

/** Add Friends Begin **/
public class GetFriendsResponse: Response {
    var data: [String: User]?
    
    enum CodingKeys : String, CodingKey {
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([String: User].self, forKey: .data)
        try super.init(from: decoder)
    }
}
/** Add Friends End **/
