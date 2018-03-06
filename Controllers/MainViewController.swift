//
//  MainViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/10/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var user: User?
    
    @IBOutlet var mainBtns: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let session_id = defaults.string(forKey: "session_id") {
            if let user_id = defaults.string(forKey: "user_id") {
                print(session_id)
                do {
                    user = try Server.getUser(user_id: user_id)
                    self.performSegue(withIdentifier: "routerSegue", sender: self)
                    
                    return
                } catch let cError as CustomError {
                    print(cError)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        mainBtns.forEach {
            $0.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "routerSegue") {
            let controller = segue.destination as! RouterTabBarController
            controller.user = user
        }
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "session_id") != nil {
            defaults.removeObject(forKey: "session_id")
        }
        
        if defaults.string(forKey: "user_id") != nil {
            defaults.removeObject(forKey: "user_id")
        }
        
        mainBtns.forEach {
            $0.isHidden = false
        }
    }

}
