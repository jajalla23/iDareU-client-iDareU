//
//  LaunchScreenViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class CheckSessionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let result = try Local.loadSession()
            checkSession()
        } catch let error {
            print(error.localizedDescription)
            performSegue(withIdentifier: "mainSegue", sender: self)
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func checkSession() {
        print("checking session...")
        let isSessionValid: Bool = true
        
        if (isSessionValid) {
            let defaults = UserDefaults.standard
            defaults.set("ABCDEF", forKey: "session_id")
            defaults.set("00000", forKey: "user_id")
            
            self.performSegue(withIdentifier: "routerSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "mainSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "routerSegue") {
            let routerController = segue.destination as! RouterTabBarController
            routerController.user = TestData.generateUser()
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
