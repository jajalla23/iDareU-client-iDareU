//
//  ServerCall.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/22/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

public class Server {
    static private var error_location = "/Auxiliary/Server.swift"
    static private let server: String = "http://34.208.110.84:3000/"
    //static private let server: String = "http://localhost:3000/"
    //static private let server: String = "http://192.168.1.109:3000/"
    
    private static func invokeHTTP (action: String, httpMethod: String, parameters: Dictionary<String, String>) {
        print("calling server...")
        //let parameters = ["name": "name", "password": "pass"] as Dictionary<String, String>
        
        let url = URL(string: self.server + action)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.synchronousDataTask(with: request as URLRequest)
        print(task)
    }
    
    private static func invokeHTTP(action: String, httpMethod: String, data: Data?, sync: Bool = true) throws -> Data? {
        print("calling server sync...")

        let url = URL(string: self.server + action)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod //set http method as POST
        request.httpBody = data
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.synchronousDataTask(with: request as URLRequest)
        return task.0
    }
    
    private static func invokeHTTP(action: String, httpMethod: String, data: Data?, async: Bool = true) throws {
        print("calling server async...")
        
        let url = URL(string: self.server + action)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = data
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            guard error == nil else {
                return
            }
         
            guard data != nil else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
         })
        task.resume()
    }
    
    public static func invokeHTTP(action: String, httpMethod: String, data: Data, type: String, filename: String, uuid: UUID, sendfile: Bool?) throws -> Data? {
        print("calling server send file...")
        
        let url = URL(string: self.server + action)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = data
        
        request.addValue(String(data.count), forHTTPHeaderField: "Content-Length")
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.addValue(uuid.uuidString, forHTTPHeaderField: "originalfilename")

        let task = session.synchronousDataTask(with: request as URLRequest)
        return task.0
    }
}

extension Server {
    static func login(username: String, password: String) throws -> User? {
        let userResp: User? = nil
        
        if (username == "test") {
            return TestData.generateUser()
        }
        
        let credentials: NSDictionary = NSMutableDictionary()
        
        credentials.setValue(username, forKey: "username")
        credentials.setValue(password, forKey: "password")
        
        var data: Data = Data()
        do {
            data = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        guard let respData = try invokeHTTP(action: "login", httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        
        do {
            if let json = try JSONSerialization.jsonObject(with: respData, options: .mutableContainers) as? [String: Any] {
                let status = json["status"] as? NSDictionary
                if (status!["code"] as? String != "001") {
                    print("error post response")
                    let error: CustomError = CustomError.init(code: status!["code"] as! String, description: status!["description"] as! String, severity: Severity.HIGH, location: self.error_location)
                    
                    throw error
                }
                
                if let data_block = json["data"] as? NSDictionary {
                    if let session_data = data_block["session"] as? String {
                        let defaults = UserDefaults.standard
                        defaults.set(session_data, forKey: "session_id")
                        
                        let user_json = data_block["user"]
                        let jsonData = try JSONSerialization.data(withJSONObject: user_json!, options: .prettyPrinted)
                        
                        let decoder = JSONDecoder()
                        let userObj = try decoder.decode(User.self, from: jsonData) as User
                        
                        print("return here")
                        userObj.identification?.password = nil
                        return userObj
                    }
                }
                
            }
        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error.localizedDescription)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: Severity.HIGH, location: self.error_location)
            
            throw customerError
        }
        
        return userResp
    }
    
    static func createNewUser(userInfo: User) throws -> User {
        var newUser = userInfo
        let encoder = JSONEncoder()
        let data = try! encoder.encode(userInfo)
        
        guard let respData = try invokeHTTP(action: "users/create", httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: respData, options: .mutableContainers) as? [String: Any] {
                let status = json["status"] as? NSDictionary
                if (status!["code"] as? String != "001") {
                    print("error post response")
                    let error: CustomError = CustomError.init(code: status!["code"] as! String, description: status!["description"] as! String, severity: Severity.HIGH, location: self.error_location)
                    
                    throw error
                }
                
                if let data_block = json["data"] as? NSDictionary {
                    if let session_data = data_block["session"] as? String {
                        let defaults = UserDefaults.standard
                        defaults.set(session_data, forKey: "session_id")
                        
                        //let user = data_block["user"] as? NSDictionary
                        //userInfo._id = user!["_id"] as? String
                        let jsonData = try JSONSerialization.data(withJSONObject: data_block["user"]!, options: .prettyPrinted)

                        let decoder = JSONDecoder()
                        newUser = try decoder.decode(User.self, from: jsonData)
                        newUser.identification?.password = nil

                    }
                }
            }
        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error.localizedDescription)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: Severity.HIGH, location: self.error_location)
            
            throw customerError
        }
        
        return newUser
    }
    
    static func getFriendFeedData(userId: String) throws -> [FriendFeed] {
        if ("a" == "a") {
            return TestData.getFriendFeed()
        } else {
            guard let respData = try invokeHTTP(action: "friends/" + userId + "/feed", httpMethod: "GET", data: nil, sync: true)
                else {
                    let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                    throw cError
            }
            
            print(respData)
            let friendFeeds: [FriendFeed] = []
            return friendFeeds
        }
    }
    
    static func createChallenge(challenges: [ChallengeDetails]) throws -> [ChallengeDetails] {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(challenges)
        guard let respData = try invokeHTTP(action: "challenges/create", httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: respData, options: .mutableContainers) as? [String: Any] {
                let status = json["status"] as? NSDictionary
                if (status!["code"] as? String != "001") {
                    print("error post response")
                    let error: CustomError = CustomError.init(code: status!["code"] as! String, description: status!["description"] as! String, severity: Severity.HIGH, location: self.error_location)
                    
                    throw error
                }
                
                if let data_block = json["data"] as? NSDictionary {
                    //for each
                    if let session_data = data_block["session"] as? String {
                        let defaults = UserDefaults.standard
                        defaults.set(session_data, forKey: "session_id")
                        
                        let user = data_block["user"] as? NSDictionary
                        challenges[0]._id = user!["_id"] as? String
                    }
                }
            }
        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error.localizedDescription)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: Severity.HIGH, location: self.error_location)
            
            throw customerError
        }
        
        return challenges
    }
    
    static func uploadMedia(media: Data, type: String, uuid: UUID) throws -> Void {
        guard let respData = try invokeHTTP(action: "media/upload", httpMethod: "POST", data: media, type: type, filename: uuid.uuidString, uuid: uuid, sendfile: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: respData, options: .mutableContainers) as? [String: Any] {
                let status = json["status"] as? NSDictionary
                if (status!["code"] as? String != "001") {
                    print("error post response")
                    let error: CustomError = CustomError.init(code: status!["code"] as! String, description: status!["description"] as! String, severity: Severity.HIGH, location: self.error_location)
                    
                    throw error
                }
            }
        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error.localizedDescription)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: Severity.HIGH, location: self.error_location)
            
            throw customerError
        }
    }
    
    static func fetchMedia(mediaName: String, mediaType: String) throws -> Data? {
        print("calling fetch media")

        let session = URLSession(configuration: .default)
        let type = ((mediaType == "image/jpg" || mediaType == "image/jpeg" || mediaType == "image/png") ? "media/image/" : "media/video/")
        let url = URL(string: self.server + type + mediaName)!
        
        let request = URLRequest(url: url)
        let task = session.synchronousDataTask(with: request)
        return task.0        
    }
}
