//
//  FriendFeedViewCell.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class FriendFeedViewCell: UITableViewCell {
    
    @IBOutlet weak var challengeRewardLbl: UILabel!
    @IBOutlet weak var friendsActivityLbl: UILabel!
    @IBOutlet weak var challengeImgPreview: UIImageView!
    
    var friendFeed: FriendFeed? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
