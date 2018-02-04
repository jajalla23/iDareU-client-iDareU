//
//  MeContainerViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MeInitialViewController: GenericUIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.scrollView.contentSize = CGSize(width: containerView.frame.size.width, height: containerView.frame.size.height)
        print(NSStringFromClass(self.classForCoder) + " : " + (self.user?._id ?? "user not set"))

        self.view.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.isScrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let routerController: RouterTabBarController = self.tabBarController as! RouterTabBarController
        let meViewController = segue.destination as? MeGenericViewController
        meViewController?.user = routerController.user
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
