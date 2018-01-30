//
//  PendingChallengesViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PendingChallengesViewController: MeParentViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.frame.size.height = CGFloat(80 * (self.user?.challengesPending?.count ?? 0))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user?.challengesPending?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingChallengeCell") as! PendingChallengeTableViewCell
        
        let currChallenge = user?.challengesPending![indexPath.row]
        
        cell.challangePrevImage.image = UIImage(named: "Play")
        cell.challengeTitleLbl.text = currChallenge?.title
        cell.challengeDescLbl.text = currChallenge?.description ?? ""
        cell.challengeRewardLbl.text = "J \(currChallenge?.reward.description ?? "0")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challenge: Challenge = (self.user?.challengesPending![indexPath.row])!
        print(challenge.id ?? "unknown")
        performSegue(withIdentifier: "pendingToWatchSegue", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
