//
//  ViewChallengeNavigationController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/11/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewChallengeNavigationController: UINavigationController {
    var user: User?
    var challengeList: [ChallengeDetails]?
    var viewType: String?

    private var challengeQueue: Queue<ChallengeDetails>?
    //private var challenge: ChallengeDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.challengeQueue = Queue(elements: challengeList!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func popChallenge() -> ChallengeDetails {
        return (self.challengeQueue?.pop())!
    }
    
    func getChallenge() -> ChallengeDetails {
        return (self.challengeQueue?.peek())!
    }
    
    func isChallengeListEmpty() -> Bool {
        return self.challengeQueue!.isEmpty
    }

}
