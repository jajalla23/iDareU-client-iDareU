//
//  ServerCall.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/22/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

extension URLSession {
    func synchronousDataTask(with url: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}

public class Server {
    static private let server: String = "http://192.168.0.105:3000/"
    
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
    
    private static func invokeHTTP_Sync (action: String, httpMethod: String, data: Data?) -> Data? {
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
    
    private static func invokeHTTP_Async (action: String, httpMethod: String, data: Data?) {
        print("calling server async...")
        
        let url = URL(string: self.server + action)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod //set http method as POST
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
        
        
        let respData = invokeHTTP_Sync(action: "login", httpMethod: "POST", data: data)
        
        do {
            if let json = try JSONSerialization.jsonObject(with: respData!, options: .mutableContainers) as? [String: Any] {
                let status = json["status"] as? NSDictionary
                if (status!["code"] as? String == "002") {
                    print("error post response")
                    let error: CustomError = CustomError.init(code: status!["code"] as! String, description: status!["description"] as! String, severity: "HIGH", location: "/Auxiliary/Server.swift")
                    
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
                        return userObj
                    }
                }
                
            }
        } catch let customError as CustomError {
            throw customError
        } catch let error {
            print(error.localizedDescription)
            let customerError: CustomError = CustomError.init(code: "003", description: error.localizedDescription, severity: "HIGH", location: "/Auxiliary/Server.swift")
            
            throw customerError
        }
        
        return userResp
    }
    
    static func createNewUser(userInfo: User) -> User {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(userInfo)
        
        let respData = invokeHTTP_Sync(action: "user/create", httpMethod: "POST", data: data)
        do {
            if let json = try JSONSerialization.jsonObject(with: respData!, options: .mutableContainers) as? [String: Any] {
                if let data_block = json["data"] as? NSDictionary {
                    if let session_data = data_block["session"] as? String {
                        let defaults = UserDefaults.standard
                        defaults.set(session_data, forKey: "session_id")
                        
                        let user = data_block["userInfo"] as? NSDictionary
                        let user_id = user!["id"] as? String
                        userInfo.id = user_id
                    }
                }
                
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return userInfo
    }
    
    static func getFriendFeedData(userId: String) -> [FriendFeed] {
        if (true) {
            let challenge1: ChallengeFriendFeed = ChallengeFriendFeed(id: "11111", title: "Challenge 1", description: "Challenge 1", reward: 50, url: "", imagePreviewURL: "Play", isCompleted: true)
            let challenge2: ChallengeFriendFeed = ChallengeFriendFeed(id: "22222", title: "Challenge 2", description: "Challenge 2", reward: 50, url: "", imagePreviewURL: "Play", isCompleted: false)
            
            let friendFeed1: FriendFeed = FriendFeed(challenge: challenge1, ownerUsername: "friendA", friendUsername: "friendB")
            let friendFeed2: FriendFeed = FriendFeed(challenge: challenge2, ownerUsername: "friendB", friendUsername: "friendA")
            let friendFeed3: FriendFeed = FriendFeed(challenge: challenge1, ownerUsername: "friendB", friendUsername: "friendA")
            let friendFeed4: FriendFeed = FriendFeed(challenge: challenge2, ownerUsername: "friendA", friendUsername: "friendB")
            
            let friendFeeds: [FriendFeed] = [friendFeed1, friendFeed2, friendFeed3, friendFeed4]
            
            return friendFeeds
        } else {
            let respData = invokeHTTP_Sync(action: "friends/" + userId + "/feed", httpMethod: "GET", data: nil)
            
            let friendFeeds: [FriendFeed] = []
            return friendFeeds
        }
        
    }
}
