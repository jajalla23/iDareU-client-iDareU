//
//  LoginViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/23/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var user: User? = nil;
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    @IBOutlet weak var loginStatusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            self.user = try Server.login(username: username_input.text!, password: password_input.text!)
            
            if (self.user != nil) {
                let defaults = UserDefaults.standard
                defaults.set(user?._id, forKey: "user_id")
                
                self.loginDone()
            }
            
        } catch let error as CustomError {
            loginStatusLbl.isHidden = false
            loginStatusLbl.text = error.description
        } catch {
            loginStatusLbl.isHidden = false
            loginStatusLbl.text = "Unknown Error"
        }
    }
    
    private func loginDone() {
        print("logged in")
        
        //let session_id = UserDefaults.standard.string(forKey: "session_id")
        //let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        //Local.saveSession(session_id: session_id ?? "", user_id: user_id ?? "")
        
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

