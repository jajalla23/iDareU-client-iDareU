//
//  DoubleDownViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class DoubleDownViewController: UIViewController {
    var challenge: ChallengeFriendFeed? = nil
    var user: User? = nil
    
    @IBOutlet weak var addToRewardTxtFld: UITextField!
    @IBOutlet weak var challengeRewardLbl: UILabel!
    @IBOutlet weak var userBalanceAvailLbl: UILabel!
    
    @IBOutlet weak var addRewardSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.challengeRewardLbl.text = "J \(self.challenge?.reward.description ?? "0")"
        self.userBalanceAvailLbl.text = "J \(self.user?.jans?.available.description ?? "0")"
        
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
        let newChallengeReward = (self.challenge?.reward ?? 0) + sliderVal
        let newUserAvailable = (self.user?.jans?.available)! - sliderVal
        //TODO: change committed
        print("new challenge reward: " + newChallengeReward.description)
        print("new user available reward: " + newUserAvailable.description)
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rewardSliderChanged(_ sender: UISlider) {
        let sliderVal = Int(sender.value)
        let challengeRewardVal = "J \(sliderVal + (self.challenge?.reward ?? 0))"
        let userBalanceVal = "J \(self.user!.jans!.available - sliderVal)"
       
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
