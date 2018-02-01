//
//  SegueAnimation.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit

class TransitionFromRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 1.0
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        src.view.window?.layer.add(transition, forKey: nil)
        src.present(dst, animated: false, completion: nil)
    }
}

class TransitionFromLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 1.0
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        src.view.window?.layer.add(transition, forKey: nil)
        src.present(dst, animated: false, completion: nil)
    }
}
