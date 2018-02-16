//
//  FriendsTVCell.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class FriendsTVCell: UITableViewCell {
    //var friend: User?
    
    @IBOutlet weak var friendImgView: UIImageView!
    @IBOutlet weak var friendLbl: UILabel!
    @IBOutlet weak var checkBox: SelectCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var onCheckBoxToggled : (() -> Void)? = nil

    @IBAction func checkBoxTapped(sender: SelectCheckBox) {
        if let onCheckBoxToggled = self.onCheckBoxToggled {
            onCheckBoxToggled()
        }
    }

}
