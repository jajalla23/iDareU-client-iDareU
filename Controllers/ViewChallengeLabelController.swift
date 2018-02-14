//
//  ViewChallengeLabelController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewChallengeLabelController: UIViewController {
    var challenge: ChallengeDetails?
    
    @IBOutlet weak var rewardValLbl: UILabel!
    @IBOutlet weak var challengeInfoLbl: UILabel!
    @IBOutlet weak var challengeDescLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        rewardValLbl.text = "J \(challenge?.reward.description ?? "0")"
        challengeDescLbl.text = challenge?.description ?? "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis"
        
        let title = challenge?.title
        var sponsor = "I"
        var dare = " DARE "
        
        var taker = "anyone"
        if (!challenge!.isForCommunity) {
            taker = challenge?.takers?[0].user.display_name ?? "???"
        }
                
        if (false) {
            sponsor = challenge!.sponsor!.display_name
            dare = " DARES "
        }
        
        challengeInfoLbl.text = sponsor + dare + taker + " TO " + title!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
