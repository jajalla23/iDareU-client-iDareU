//
//  MyChallengesViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/28/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MyCreatedChallengesViewController: MeParentViewController, UITableViewDataSource, UITableViewDelegate {
       
    @IBOutlet weak var createdChallengeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //myChallengeTableView.delegate = self
        //myChallengeTableView.dataSource = self
        
        //myChallengeTableView.sectionHeaderHeight = 1.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.challengesOwned!.count
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 50
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return 5.0
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    */
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.text = user?.challengesOwned![section].title
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = createdChallengeTableView.dequeueReusableCell(withIdentifier: "createdChallengeCell") as! CollapsibleTableViewCell
        /*cell.myChallTitleLbl.text = user?.challengesOwned![indexPath.row].title
        cell.myChallDescLbl.text = user?.challengesOwned![indexPath.row].description
        cell.myChallRewardLbl.text = "J \(user?.challengesOwned![indexPath.row].reward.description ?? "0")"
        cell.myChallPrevImg.image = UIImage(named: "Play")
        
        cell.layer.cornerRadius = cell.frame.height / 2*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastitem = user!.challengesOwned!.count - 1
        
        if (indexPath.row == lastitem) {
            //loadMoreChallenges()
        }
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
