//
//  CompletedChallengesViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class CompletedChallengesViewController: MeGenericViewController, UITableViewDataSource, UITableViewDelegate {

    private var selectedChallenge: ChallengeDetails?
    private var tableContents: [ChallengeDetails]?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    public static let scrollViewMaxHeight: CGFloat = CGFloat(80 * 5) //row height x number of cells
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableContents = self.user?.challenges?.completed
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.adjustHeight()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func reloadTableData(){
        self.tableContents = self.user?.challenges?.completed
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.adjustHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedChallengeCell") as! CompletedChallengeTableViewCell
        
        let currChallenge = user?.challenges?.completed![indexPath.row]
        
        cell.challangePrevImage.image = UIImage(named: "Play")
        cell.challengeTitleLbl.text = currChallenge?.title
        cell.challengeRewardLbl.text = "J \(currChallenge?.reward.description ?? "0")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedChallenge = (self.user?.challenges?.completed![indexPath.row])!
        performSegue(withIdentifier: "completedToWatchSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastitem = tableContents!.count - 1
        
        if (indexPath.row == lastitem) {
            //TODO: loadMoreChallenges()
        }
    }
    
    private func adjustHeight() {
        let tableViewHeight: CGFloat = CGFloat(80 * (self.user?.challenges?.completed?.count ?? 0))
        self.tableView.frame.size.height = tableViewHeight
        
        self.scrollView.contentSize = CGSize(width: self.tableView.frame.size.width, height: tableViewHeight)
        
        if (tableViewHeight > CompletedChallengesViewController.scrollViewMaxHeight) {
            self.scrollView.frame.size.height = CompletedChallengesViewController.scrollViewMaxHeight
        } else {
            self.scrollView.frame.size.height = tableViewHeight
        }
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "completedToWatchSegue") {
            let controller = segue.destination as! ViewChallengeNavigationController
            controller.viewType = "COMPLETED"
            controller.user = self.user
            controller.challengeList = [self.selectedChallenge!]
            controller.navigationItem.hidesBackButton = false
        }
    }
    
    func collapseView() {
        self.tableContents?.removeAll()
        self.reloadTableData()
    }
    
    func expandView() {
        self.tableContents = self.user?.challenges?.completed
        self.reloadTableData()
        view.layoutIfNeeded()
    }

}
