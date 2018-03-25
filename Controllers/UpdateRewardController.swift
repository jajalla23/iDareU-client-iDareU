//
//  DoubleDownViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class UpdateChallengeRewardController: UIViewController {
    var source: String?
    var user: User?
    var challenge_id: String?
    var challenge_reward: Int?
    var challenge_title: String?
    
    var viewTitle: String?
    var viewAction: String?
    
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var viewActionLbl: UILabel!
    @IBOutlet weak var addToRewardTxtFld: UITextField!
    @IBOutlet weak var challengeRewardLbl: UILabel!
    @IBOutlet weak var userBalanceAvailLbl: UILabel!
    
    @IBOutlet weak var addRewardSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewTitleLbl.text = (self.viewTitle ?? "")
        self.viewActionLbl.text = (self.viewAction ?? "")
        
        self.challengeRewardLbl.text = "J \(self.challenge_reward?.description ?? "0")"
        
        var temp_avail = self.user?.jans?.available
        if (self.source == "SETUP") {
            temp_avail = temp_avail! - challenge_reward!
        }
        self.userBalanceAvailLbl.text = "J \(temp_avail?.description ?? "0")"
        
        let half = (self.user?.jans?.available ?? 0)/2
        
        if (half > 0) {
            self.addToRewardTxtFld.text = String(describing: half)
        }
        
        self.addRewardSlider.minimumValue = 1
        self.addRewardSlider.maximumValue = Float(self.user?.jans?.available ?? 0)
        self.addRewardSlider.value = Float(half)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        let sliderVal = Int(self.addRewardSlider.value)
        var newChallengeReward = (self.challenge_reward ?? 0) + sliderVal
        let newUserAvailable = (self.user?.jans?.available)! - sliderVal
        
        if (self.source == "SETUP") {
            newChallengeReward = sliderVal
        }
        //TODO: change committed
        print("new challenge reward: " + newChallengeReward.description)
        print("new user available reward: " + newUserAvailable.description)
        
        if (self.source == "SETUP") {
            self.performSegue(withIdentifier: "setupRewardUnwind", sender: self)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rewardSliderChanged(_ sender: UISlider) {
        let sliderVal = Int(sender.value)
        var challengeRewardVal = "J \(sliderVal + self.challenge_reward!)"
        let userBalanceVal = "J \(self.user!.jans!.available - sliderVal)"
        
        if (self.source == "SETUP") {
            challengeRewardVal = "J \(sliderVal)"
        }
       
        UIView.animate(withDuration: 0.3, animations: {
            self.addToRewardTxtFld.text = String(describing: Int(sliderVal))
            self.challengeRewardLbl.text = challengeRewardVal.description
            self.userBalanceAvailLbl.text = userBalanceVal.description
            
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func addToRewardEdited(_ sender: Any) {
        if (Int(self.addToRewardTxtFld.text!)! > (self.user?.jans?.available)!) {
            self.addRewardSlider.value = Float((self.user?.jans?.available)!)
        } else {
            self.addRewardSlider.value = Float(Int(self.addToRewardTxtFld.text!) ?? 0)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "setupRewardUnwind") {
            let controller = segue.destination as! SetupChallengeViewController
            if (controller.challenge?.sponsor == nil) {
                controller.challenge!.addSponsor(user: self.user!, reward: Int(self.addRewardSlider.value))
            } else {
                controller.challenge?.updateSponsorReward(reward: Int(self.addRewardSlider.value))
            }
            controller.challengeRewardBtn.setTitle(self.challengeRewardLbl.text!, for: UIControlState.normal)
        }
    }
}
