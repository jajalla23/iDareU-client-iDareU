//
//  ViewChallengeLabelController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewChallengeLabelController: UIViewController {
    var user: User?
    var challenge: ChallengeDetails?
    
    @IBOutlet weak var rewardValLbl: UILabel!
    @IBOutlet weak var challengeInfoLbl: UILabel!
    @IBOutlet weak var challengeDescLbl: UILabel!
    
    //public var infoLabel: UILabel?
    //public var rewardLabel: UILabel?
    //public var descLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func load() {
        load(infoLabel: challengeInfoLbl, rewardLabel: rewardValLbl, descLabel: challengeDescLbl)
    }
    
    public func load(infoLabel: UILabel, rewardLabel: UILabel, descLabel: UILabel) {
        rewardLabel.text = "J \(challenge?.reward.description ?? "0")"
        descLabel.text = challenge?.description ?? "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis"
        
        let title = challenge?.title ?? "???"
        var sponsor = "I"
        var dare = " DARE "
        
        var taker = "anyone"
        
        if (challenge?.sponsor?._id != user?._id) {
            sponsor = challenge?.sponsor?.display_name ?? "???"
            dare = " DARES "
            taker = "YOU"
        } else {
            if ((challenge?.takers?.count ?? 0) == 0) {
                taker = "nobody"
            } else if ((challenge?.takers?.count ?? 0) > 1) {
                taker = "people"
            } else {
                taker = challenge?.takers?[0].user.display_name ?? user?.friends![(challenge?.takers?[0].user._id)!]?.display_name ?? "???"
            }
        }
        
        if ((challenge?.isForCommunity ?? false)) {
            taker = "anyone"
        }
        
        infoLabel.text = sponsor + dare + taker + " TO " + title
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
