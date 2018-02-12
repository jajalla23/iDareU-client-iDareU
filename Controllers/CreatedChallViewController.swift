//
//  MyChallengesViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/28/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MyCreatedChallengesViewController: MeGenericViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var selectedChallenge: ChallengeDetails?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    public static let scrollViewMaxHeight: CGFloat = CGFloat(80 * 5) //row height x number of cells

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.adjustHeight()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func reloadTableData(){
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.adjustHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.challenges?.sponsored?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createdChallengeCell") as! CreatedChallengeTableViewCell
        
        let currChallenge = user?.challenges?.sponsored![indexPath.row]
        
        cell.challangePrevImage.image = UIImage(named: "Play")
        cell.challengeTitleLbl.text = currChallenge?.title
        cell.challengeDescLbl.text = currChallenge?.description ?? ""
        cell.challengeRewardLbl.text = "J \(currChallenge?.reward.description ?? "0")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedChallenge = (self.user?.challenges?.sponsored![indexPath.row])!
        performSegue(withIdentifier: "createdToWatchSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastitem = (user!.challenges?.sponsored!.count)! - 1
        
        if (indexPath.row == lastitem) {
            //TODO: loadMoreChallenges()
        }
    }
    
    private func adjustHeight() {
        let tableViewHeight: CGFloat = CGFloat(80 * (self.user?.challenges?.sponsored?.count ?? 0))
        self.tableView.frame.size.height = tableViewHeight
        
        self.scrollView.contentSize = CGSize(width: self.tableView.frame.size.width, height: tableViewHeight)
        
        if (tableViewHeight > MyCreatedChallengesViewController.scrollViewMaxHeight) {
            self.scrollView.frame.size.height = MyCreatedChallengesViewController.scrollViewMaxHeight
        } else {
            self.scrollView.frame.size.height = tableViewHeight
        }
        
        self.view.layoutIfNeeded()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createdToWatchSegue") {
            let controller = segue.destination as! ViewChallengeNavigationController
            controller.challenge = self.selectedChallenge
            controller.navigationItem.hidesBackButton = false
        }
    }
    

}
