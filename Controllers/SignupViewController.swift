//
//  SignupViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/22/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {
    var user: User? = nil
    
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var password1TxtFld: UITextField!
    @IBOutlet weak var password2TxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    
    @IBOutlet weak var signUpStatusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        signUpStatusLbl.isHidden = true
        do {
            //TODO: validate
            if (password1TxtFld.text! != password2TxtFld.text) {
                let error: CustomError = CustomError.init(code: "002", description: "Paswords do not match!", severity: Severity.LOW, location: "/Controllers/SignupViewController.swift")
                
                throw error
            }
            
            var newUser: User = User(username: userNameTxtFld.text!, password: password1TxtFld.text!, email: emailTxtFld.text!)
            let response = try Server.createNewUser(userInfo: newUser)
            newUser = response[0] as! User
            if newUser._id != nil {
                let defaults = UserDefaults.standard
                defaults.set(newUser._id, forKey: "user_id")
                defaults.set(response[1] as! String, forKey: "session_id")

                self.user = newUser
                self.performSegue(withIdentifier: "signupToRouterSegue", sender: sender)
            }
            
        } catch let error as CustomError {
            signUpStatusLbl.isHidden = false
            signUpStatusLbl.text = error.description
        } catch {
            signUpStatusLbl.isHidden = false
            signUpStatusLbl.text = "Unknown Error"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "signupToRouterSegue") {
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

//let formValidMgr = SignupFormValidationModel(userEmail: emailTxtFld.text!, userName: userNameTxtFld.text!, userPassword: password1TxtFld.text!)
//SignupValidationManager.validateForm(signUpModel: formValidMgr)
