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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        print("submit")
        //TODO: validate

        var newUser: User = User(username: userNameTxtFld.text!, password: password1TxtFld.text!, email: emailTxtFld.text!)
        newUser = Server.createNewUser(userInfo: newUser)
        if newUser.id?.count != 0 {
            let defaults = UserDefaults.standard
            defaults.set(newUser.id, forKey: "user_id")
            
            //let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newUser)
            //defaults.set(encodedData, forKey: "user")
            self.user = newUser
            self.performSegue(withIdentifier: "signupToRouterSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "signupToRouterSegue") {
            let captureController = segue.destination as! CaptureViewController
            captureController.user = self.user
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
