//
//  CommunityViewCell.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/12/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class CommunityViewCell: UITableViewCell {
    
    @IBOutlet weak var challengeView: UIView!
    @IBOutlet weak var challengeImgPreview: UIImageView!
    @IBOutlet weak var challengeTitleLbl: UILabel!
    @IBOutlet weak var challengeDescLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
