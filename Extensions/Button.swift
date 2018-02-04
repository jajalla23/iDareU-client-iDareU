//
//  Button.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/31/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit

class SelectUserCheckBox: UIButton {
    var isCommunity: Bool = false
    var friend: User?

    // Images
    let checkedImage = UIImage(named: "checked")! as UIImage
    let uncheckedImage = UIImage(named: "unchecked")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
