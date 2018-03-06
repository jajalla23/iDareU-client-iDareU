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
    //@IBOutlet weak var containerViewHeightConstr: NSLayoutConstraint!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.navigationController?.isNavigationBarHidden = true
        self.scrollView.contentSize = CGSize(width: containerView.frame.size.width, height: containerView.frame.size.height)
        self.scrollView.contentInsetAdjustmentBehavior = .never
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
        do {
            self.user = try Server.getUser(user_id: (self.user?._id)!)
            
            if let meViewContr = self.childViewControllers.first as? MeViewController {
                meViewContr.refreshAllViews_v2(user: self.user!)
            }
        } catch let cError as CustomError {
            print(cError.description)
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileSegue") {
            let controller = segue.destination as! ProfileNaviController
            controller.user = self.user
            
        } else {
            let routerController: RouterTabBarController = self.tabBarController as! RouterTabBarController
            let meViewController = segue.destination as? MeViewController
            meViewController?.delegate = self
            meViewController?.user = routerController.user
        }
    }
    
    @IBAction func leftBarBtnTapped(_ sender: UIBarButtonItem) {
        //TODO: profile settings
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure to want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.logout()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            return
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func edgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        let tabController = self.tabBarController as! RouterTabBarController
        
        if (sender.edges == .left) {
            tabController.selectedIndex = 0
        } else {
            tabController.selectedIndex = 2
        }
    }
    
    private func logout() {
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}

extension MeInitialViewController: MeViewControllerDelegate {
    func adjustView(meViewController: MeViewController) {
        //let totalViewHeight = meViewController.pendingChallengesHeightConstr.constant + meViewController.myStatusHeightConstr.constant + meViewController.createdChallengesHeightConstr.constant
        //let totalHeaderHeight = CGFloat.init(200)

        //self.containerViewHeightConstr.constant = totalHeaderHeight + totalViewHeight
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: scrollView.contentOffset.y), animated: true)
    }
    
    
}
