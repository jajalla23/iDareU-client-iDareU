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
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.navigationController?.isNavigationBarHidden = true
        self.scrollView.contentSize = CGSize(width: containerView.frame.size.width, height: containerView.frame.size.height)
        print(NSStringFromClass(self.classForCoder) + " : " + (self.user?._id ?? "user not set"))

        self.view.layoutIfNeeded()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        scrollView.refreshControl = self.refreshControl

        //NSStringFromClass(self.classForCoder)
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.isScrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(sender: AnyObject) {
        //TODO: refresh me-info
        self.refreshControl?.endRefreshing()
        print("initial view refresh done")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let routerController: RouterTabBarController = self.tabBarController as! RouterTabBarController
        let meViewController = segue.destination as? MeGenericViewController
        meViewController?.user = routerController.user
    }
    
    @IBAction func leftBarBtnTapped(_ sender: UIBarButtonItem) {
        //TODO: profile settings
    }
    
}
