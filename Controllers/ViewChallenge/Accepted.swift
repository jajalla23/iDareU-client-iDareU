//
//  ViewAcceptedChallengeController.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/25/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewAcceptedChallengeController: ViewPendingChallengeController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.swipeRightImage = #imageLiteral(resourceName: "complete")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cameraSegue") {
            let controller = segue.destination as? CameraController
            controller?.challenge = self.challenge
            controller?.user = naviController.user
            
            for taker in (challenge?.takers)! {
                if (taker.user._id == controller?.user?._id) {
                    controller?.taker = taker
                    break
                }
            }
        }
    }
    
    public func swipeRight() {
        performSegue(withIdentifier: "cameraSegue", sender: self)
    }
}
