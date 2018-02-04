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
    public var image: UIImage?
    
    //challengeinfo
    public var challenge: ChallengeDetails?
    
    public var sponsors: [User]?
    
    @IBOutlet weak var sponsorBtn: UIButton!
    @IBOutlet weak var takerBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var expirationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor.clear
        //view.isOpaque = false

        if (challenge == nil) {
            challenge = ChallengeDetails.init(sponsorId: self.user?._id ?? "00000", title: "New Challenge", description: "", reward: 0)
            self.sponsors = []
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sponsorBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "selectSponsorSegue" , sender : self)
    }
    
    @IBAction func takerBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "selectTakerSegue", sender: sender)
    }
    
    @IBAction func expirationBtnTapped(_ sender: Any) {
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        if (self.sponsors!.count == 0) {
            self.user?.challenges?.addSponsoredChallenge(challengeDetail: self.challenge!)
            //update server to add to sponsored challenge
            
        } else {
            let split_reward = self.challenge!.reward/self.sponsors!.count
            let main_sponsor = self.sponsors!.popLast()
            
            self.challenge?.addSponsor(user: main_sponsor!, reward: split_reward)
            
            for sponsor in self.sponsors! {
                self.challenge?.addCosponsor(user: sponsor, reward: split_reward)
            }
            
            self.user?.addPendingChallenges(challengeDetail: self.challenge!)

            //Update server to add pending challenge
        }
        
        performSegue(withIdentifier: "setupToCreateUnwind", sender: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier!) {
        case "selectTakerSegue":
            guard let controller = segue.destination as? SelectTakerTableViewController else {
                return
            }
            controller.allFriends = Array(self.user!.friends!.values)
            
            if ((self.challenge?.takers?.count ?? 0) > 0) {
                controller.selectedFriends = [String: User]()
                for taker in self.challenge!.takers! {
                    controller.selectedFriends![taker.user._id!] = taker.user
                }
            }
            
            if (self.challenge!.isForCommunity) {
                controller.isCommunityChecked = true
            }
        case "selectSponsorSegue":
            guard let controller = segue.destination as? SelectSponsorTableViewController else {
                return
            }
            controller.user = self.user
            controller.challengeToBeSetup = self.challenge
            controller.allFriends = Array(self.user!.friends!.values)
            
            if ((self.sponsors?.count ?? 0) > 0) {
                controller.selectedFriends = [String: User]()
                for sponsor in self.sponsors! {
                    controller.selectedFriends![sponsor._id!] = sponsor
                }
            }
        case "setupToCreateUnwind":
            guard let controller = segue.destination as? GenericUIViewController else {
                return
            }
            
            let tabController = controller.tabBarController as! RouterTabBarController
            tabController.user = self.user
            //NSStringFromClass(self.classForCoder)
            
        case "sendChallengeSegue":
            guard let controller = segue.destination as? RouterTabBarController else {
                return
            }
            
            controller.user = self.user
            self.navigationController?.popViewController(animated: false)
            self.dismiss(animated: false, completion: nil)
            
        default:
            return
        }
    }
    
    @IBAction func unwindToSetupChallenge(segue: UIStoryboardSegue) {}
    
}
