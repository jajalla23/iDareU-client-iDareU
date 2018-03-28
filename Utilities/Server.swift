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
    //static private let server: String = "http://192.168.0.105:3000/"
    
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
        request.httpBody = data ?? nil
        
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
    
    private static func invokeHTTP(action: String, httpMethod: String, data: Data, type: String, filename: String, uuid: UUID, sendfile: Bool?) throws -> Data? {
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
    static func login(username: String, password: String) throws -> [Any?] {
        let userResp: User? = nil
        
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
            let response = try JSONDecoder().decode(LoginResponse.self, from: respData)
            
            if (response.error != nil) {
                print(response.error?.description ?? "error")
                throw response.error!
            }

            if (response.status?.code != "001") {
                let status = response.status
                let customerError: CustomError = CustomError.init(code: (status?.code ?? "009"), description: (status?.description ?? "unknown error"), severity: Severity.HIGH, location: self.error_location)
                
                throw customerError
            }
            print("login success")
            
            if let data = response.data {                
                data.user?.identification?.password = nil
                return [data.user!, (data.session ?? "")]
            }

        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: Severity.HIGH, location: self.error_location)
            
            throw customerError
        }
        
        return [userResp, ""]
    }
    
    static func createNewUser(userInfo: User) throws -> [Any?] {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(userInfo)
        
        guard let respData = try invokeHTTP(action: "users/create", httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {           
            let response = try JSONDecoder().decode(CreateUserResponse.self, from: respData)
        
            if (response.error != nil) {
                print(response.error?.description ?? "error")
                throw response.error!
            }
        
            if let data = response.data {
                let defaults = UserDefaults.standard
                defaults.set(data.session, forKey: "session_id")
                
                data.user?.identification?.password = nil
                return [data.user!, (data.session ?? "")]
            }
            
        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error.localizedDescription)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: Severity.HIGH, location: self.error_location)
            
            throw customerError
        }
        
        return [userInfo, ""]
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
            let decoder = JSONDecoder()
            let response: CreateChallengeResponse = try decoder.decode(CreateChallengeResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
            
            return response.data!
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }        
    }
    
    static func uploadMedia(media: Data, type: String, uuid: UUID) throws -> Void {
        guard let respData = try invokeHTTP(action: "media/upload", httpMethod: "POST", data: media, type: type, filename: uuid.uuidString, uuid: uuid, sendfile: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: respData)
            
            if (response.error != nil) {
                print("error post response")
                let error: CustomError = CustomError.init(code: response.error!.code, description: response.error!.description, severity: Severity.HIGH, location: self.error_location)
                
                throw error
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
    
    static func getOtherUsers(user_id: String, friends: [User]) throws -> [User]? {       
        let encoder = JSONEncoder()
        let data = try! encoder.encode(friends)
        
        guard let respData = try invokeHTTP(action: "users/notfriends/" + user_id, httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: GetOtherUsersResponse = try decoder.decode(GetOtherUsersResponse.self, from: respData)

            if (response.error != nil) {
                throw response.error!
            }

            return response.data
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
    
    static func addFriends(user_id: String, friends: [User]) throws -> Void {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(friends)
        
        guard let respData = try invokeHTTP(action: "users/addfriends/" + user_id, httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: Response = try decoder.decode(Response.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }            
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
    
    static func getFriends(user_id: String) throws -> [String: User] {
        guard let respData = try invokeHTTP(action: "users/friends/" + user_id, httpMethod: "GET", data: nil, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: GetFriendsResponse = try decoder.decode(GetFriendsResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
            
            guard let friends = response.data
                else {
                    let cError: CustomError = CustomError.init(code: "005", description: "Data Missing", severity: Severity.HIGH, location: error_location)
                    throw cError
            }
            
            return friends
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
    
    static func acceptChallenge(user_id: String, challenge_id: String) throws {
        guard let respData = try invokeHTTP(action: "challenges/accept/" + challenge_id + "/" + user_id, httpMethod: "POST", data: nil, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: UpdateResponse = try decoder.decode(UpdateResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
            
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
    
    static func declineChallenge(user_id: String, challenge_id: String) throws {
        guard let respData = try invokeHTTP(action: "challenges/decline/" + challenge_id + "/" + user_id, httpMethod: "POST", data: nil, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: UpdateResponse = try decoder.decode(UpdateResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
            
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
    
    static func getUser(user_id: String) throws -> User {
        guard let respData = try invokeHTTP(action: "users/" + user_id, httpMethod: "GET", data: nil, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: GetUserResponse = try decoder.decode(GetUserResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
            
            return response.data!
            
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }

    static func addTakers(challenge_id: String, new_takers: [Taker]) throws {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(new_takers)
        
        guard let respData = try invokeHTTP(action: "challenges/addTakers/" + challenge_id, httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: UpdateResponse = try decoder.decode(UpdateResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
                        
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
    
    static func completeChallenge(challenge_id: String, taker: Taker) throws {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(taker)
        
        guard let respData = try invokeHTTP(action: "challenges/completed/" + challenge_id + "/" + taker.user._id!, httpMethod: "POST", data: data, sync: true)
            else {
                let cError: CustomError = CustomError.init(code: "002", description: "Unable to call server", severity: Severity.HIGH, location: error_location)
                throw cError
        }
        
        do {
            let decoder = JSONDecoder()
            let response: UpdateResponse = try decoder.decode(UpdateResponse.self, from: respData)
            
            if (response.error != nil) {
                throw response.error!
            }
            
        } catch let error {
            let cError: CustomError = CustomError.init(code: "002", description: error.localizedDescription, severity: Severity.HIGH, location: error_location)
            throw cError
        }
    }
}
