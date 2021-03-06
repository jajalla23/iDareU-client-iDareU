//
//  LoginViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/23/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    var user: User?
    
    private let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    private var fbLoginManager: FBSDKLoginManager?
    private var loginSuccessful: Bool = false
    
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    @IBOutlet weak var loginStatusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        username_input.delegate = self
        password_input.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && self.loginSuccessful == true) {
            self.fbloginSuccess()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        do {
            let response = try Server.login(username: username_input.text!, password: password_input.text!)
            self.user = response[0] as? User
            
            if (self.user != nil) {
                loginStatusLbl.text = "Success!"
                self.loginDone(user: user!, session: response[1] as! String)
            }
        } catch let error as CustomError {
            loginStatusLbl.isHidden = false
            loginStatusLbl.text = error.description
        } catch {
            loginStatusLbl.isHidden = false
            loginStatusLbl.text = "Unknown Error"
        }
    }
    
    @IBAction func fbBtnTapped(_ sender: Any) {
        fbLoginManager = FBSDKLoginManager()
        fbLoginManager!.logIn(withReadPermissions: self.facebookReadPermissions, from: self, handler: { (result, error) -> Void in
            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.loginSuccessful = true
                    //fbLoginManager.logOut()
                }
            } else {
                self.loginStatusLbl.isHidden = false
                self.loginStatusLbl.text = error?.localizedDescription
            }
        })
    }
    
    private func fbloginSuccess() {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let result_dict = result as! NSDictionary

                    //print(result_dict)
                    let email = result_dict["email"] as! String
                    let fb_id = result_dict["id"] as! String
                    let first_name = result_dict["first_name"] as! String
                    let last_name = result_dict["last_name"] as! String
                    
                    let temp = User.init(facebook_id: fb_id, email: email, firstName: first_name, lastName: last_name)
                    
                    self.createGetUser(newUser: temp)
                }
            })
        }
    }
    
    private func createGetUser(newUser: User) {
        do {
            let response = try Server.createNewUser(userInfo: newUser)
            self.user = response[0] as? User
            if self.user!._id != nil {
                self.loginDone(user: user!, session: response[1] as! String)
            }
            
        } catch let error as CustomError {
            loginStatusLbl.isHidden = false
            loginStatusLbl.text = error.description
            self.fbLoginManager!.logOut()
        } catch {
            loginStatusLbl.isHidden = false
            loginStatusLbl.text = "Unknown Error"
            self.fbLoginManager!.logOut()
        }
    }
    
    private func loginDone(user: User, session: String) {
        print("logged in")
        
        let defaults = UserDefaults.standard
        defaults.set(session, forKey: "session_id")
        defaults.set(user._id, forKey: "user_id")
        
        self.performSegue(withIdentifier: "loginToRouterSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginToRouterSegue") {
            
            let routerController = segue.destination as! RouterTabBarController
            routerController.user = self.user
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

