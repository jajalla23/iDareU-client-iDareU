//
//  PendingChallengeTableViewCell.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PendingChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var challengePrevImage: UIImageView!
    @IBOutlet weak var noActionIndicatorView: UIView!
    @IBOutlet weak var acceptedIndicatorView: UIView!
    @IBOutlet weak var challengeTitleLbl: UILabel!
    @IBOutlet weak var challengeRewardLbl: UILabel!
    @IBOutlet weak var expirationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
