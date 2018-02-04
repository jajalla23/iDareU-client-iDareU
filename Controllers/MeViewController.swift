//
//  MeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MeViewController: MeGenericViewController {
    private var isMyStatusExpanded: Bool = true
    @IBOutlet weak var myStatusHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var myStatusView: UIView!
    
    private var isPendingChallengesExpanded: Bool = false
    private var pendingChallengeRowHeight: Int = 80
    @IBOutlet weak var pendingChallengesHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var pendingChallengesView: UIView!
    
    private var isCreatedChallengesExpanded: Bool = false
    private var createdChallengeRowHeight: Int = 80
    @IBOutlet weak var createdChallengesHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var createdChallengesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true

        //pending challenges minimized
        //self.isPendingChallengesExpanded = false
        self.pendingChallengesHeightConstr.constant = 0
        self.pendingChallengesView.isHidden = true
        
        //created challenges minimized
        //self.isPendingChallengesExpanded = false
        self.createdChallengesHeightConstr.constant = 0
        self.createdChallengesView.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        var controller : PendingChallengesViewController = self.childViewControllers[1] as! PendingChallengesViewController
        controller.reloadTableView()
        controller.viewWillAppear(true)
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? MeGenericViewController
        controller?.user = self.user
    }
    
    @IBAction func myStatusBtnToggled(_ sender: Any) {
        self.toggleStatusView()
        
        if self.isCreatedChallengesExpanded {
            self.toggleCreatedChallengesView()
        }
        
        //TODO: toggle completed challenges
    }
    
    @IBAction func pendingChallBtnToggled(_ sender: Any) {
        self.togglePendingChallengesView()
        
        //TODO: toggle completed challenges
    }
    
    @IBAction func createdChallBtnToggled(_ sender: Any) {
        self.toggleCreatedChallengesView()
        
        if self.isMyStatusExpanded {
            self.toggleStatusView()
        }
    }
    
    @IBAction func completedChallBtnToggled(_ sender: Any) {
        self.toggleCompletedChallengesView()
        
        if self.isMyStatusExpanded {
            self.toggleStatusView()
        }
        
        if self.isPendingChallengesExpanded {
            self.togglePendingChallengesView()
        }
    }
    
    private func toggleStatusView() {
        if (isMyStatusExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.myStatusHeightConstr.constant = 0
                self.myStatusView.isHidden = !self.myStatusView.isHidden
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.myStatusHeightConstr.constant = 500
                self.myStatusView.isHidden = !self.myStatusView.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
        isMyStatusExpanded = !isMyStatusExpanded
    }
    
    private func togglePendingChallengesView() {
        if (isPendingChallengesExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.pendingChallengesHeightConstr.constant = 0
                self.pendingChallengesView.isHidden = !self.pendingChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                var height: CGFloat = CGFloat(self.pendingChallengeRowHeight * (self.user?.challenges?.pending?.count ?? 0))
                
                if (height > PendingChallengesViewController.scrollViewMaxHeight) {
                    height = PendingChallengesViewController.scrollViewMaxHeight
                }
                
                self.pendingChallengesHeightConstr.constant = height
                self.pendingChallengesView.isHidden = !self.pendingChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
        isPendingChallengesExpanded = !isPendingChallengesExpanded
    }
    
    private func toggleCreatedChallengesView() {
        if (isCreatedChallengesExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.createdChallengesHeightConstr.constant = 0
                self.createdChallengesView.isHidden = !self.createdChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                var height: CGFloat = CGFloat(self.createdChallengeRowHeight * (self.user?.challenges?.sponsored?.count ?? 0))
                
                if (height > MyCreatedChallengesViewController.scrollViewMaxHeight) {
                    height = MyCreatedChallengesViewController.scrollViewMaxHeight
                }
                
                self.createdChallengesHeightConstr.constant = height
                self.createdChallengesView.isHidden = !self.createdChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
        isCreatedChallengesExpanded = !isCreatedChallengesExpanded
    }
    
    private func toggleCompletedChallengesView() {
        
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
