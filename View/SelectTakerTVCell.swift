//
//  SelectTakerTVCell.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/31/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SelectTakerTVCell: UITableViewCell {
    
    @IBOutlet weak var friendUsernameLbl: UILabel!
    @IBOutlet weak var cellCheckbox: SelectUserCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
