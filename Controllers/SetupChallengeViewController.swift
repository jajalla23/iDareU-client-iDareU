//
//  SetupChallengeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/2/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SetupChallengeViewController: UIViewController, UIPopoverControllerDelegate {
    
    public var user: User?
    
    //challengeinfo
    public var challenge: ChallengeDetails?
    
    @IBOutlet weak var sponsorBtn: UIButton!
    @IBOutlet weak var takerBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var expirationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor.clear
        //view.isOpaque = false

        challenge = ChallengeDetails.init(sponsorId: self.user?._id ?? "00000", title: "New Challenge", description: "", reward: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSetupChallenge(segue: UIStoryboardSegue) {}

    
    @IBAction func sponsorBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "selectSponsorSegue" , sender : self)
    }
    
    @IBAction func takerBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "selectTakerSegue", sender: sender)
    }
    
    @IBAction func expirationBtnTapped(_ sender: Any) {
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectTakerSegue") {
            guard let controller = segue.destination as? SelectTakerTableViewController else {
                return
            }
            controller.allFriends = Array(self.user!.friends!.values)
        } else if (segue.identifier == "selectSponsorSegue") {
            guard let controller = segue.destination as? SelectSponsorTableViewController else {
                return
            }
            controller.allFriends = Array(self.user!.friends!.values)
        }
    }
    
}
