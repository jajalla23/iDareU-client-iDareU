//
//  CreatedChallTVCell.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class CreatedChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var challangePrevImage: UIImageView!
    @IBOutlet weak var challengeTitleLbl: UILabel!
    @IBOutlet weak var challengeDescLbl: UILabel!
    @IBOutlet weak var challengeRewardLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
