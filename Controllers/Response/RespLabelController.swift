//
//  RespLabelController.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/25/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ResponseLabelController: ViewChallengeLabelController {
    @IBOutlet weak var rewardLbl2: UILabel!
    @IBOutlet weak var challengeInfoLbl2: UILabel!
    @IBOutlet weak var challengeDescLbl2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func load() {
        load(infoLabel: challengeInfoLbl2, rewardLabel: rewardLbl2, descLabel: challengeDescLbl2)
    }
}
