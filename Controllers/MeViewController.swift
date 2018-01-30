//
//  MeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    var user: User? = nil
    
    var isMyStatusExpanded: Bool = true
    @IBOutlet weak var myStatusHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var myStatusView: UIView!
    
    var isPendingChallengesExpanded: Bool = true
    @IBOutlet weak var pendingChallengesHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var pendingChallengesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meViewController = segue.destination as? MeParentViewController
        meViewController?.user = self.user
        
        /*
        if (segue.identifier == "meToPendingSegue") {
            let viewController = segue.destination as? PendingChallengesViewController
            viewController?.tableView.frame.size.height = CGFloat(80 * (self.user?.challengesPending?.count ?? 0))

        }
        */
        
    }
    
    @IBAction func myStatusBtnToggled(_ sender: Any) {
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
    
    @IBAction func pendingChallBtnToggled(_ sender: Any) {
        if (isPendingChallengesExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.pendingChallengesHeightConstr.constant = 0
                self.pendingChallengesView.isHidden = !self.pendingChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        } else {
            print("pendin challenge view height: " + self.pendingChallengesView.frame.size.height.description)
            UIView.animate(withDuration: 1.0, animations: {
                self.pendingChallengesHeightConstr.constant = CGFloat(80 * (self.user?.challengesPending?.count ?? 0))
                self.pendingChallengesView.isHidden = !self.pendingChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
        isPendingChallengesExpanded = !isPendingChallengesExpanded
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
