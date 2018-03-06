//
//  RouterTabBarController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/28/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class RouterTabBarController: UITabBarController, UITabBarControllerDelegate {
    var user: User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserData), name: NSNotification.Name(rawValue: "refreshUserData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("router segue")
        let controller = segue.destination as! GenericUIViewController
        controller.user = self.user
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // just return the custom TransitioningObject object that conforms to UIViewControllerAnimatedTransitioning protocol
        let animatedTransitioningObject = TransitioningObject()
        animatedTransitioningObject.fromIndex = tabBarController.selectedIndex
        animatedTransitioningObject.toIndex = tabBarController.viewControllers?.index(of: toVC)
        return animatedTransitioningObject
    }

    @objc func refreshUserData(_ notification: NSNotification){
        if let updatedUser = notification.userInfo?["user"] as? User {
            self.user = updatedUser
        }
    }
}
