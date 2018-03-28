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
    private var tableContents: [ChallengeDetails]?

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    public static let scrollViewMaxHeight: CGFloat = CGFloat(80 * 5) //row height x number of cells

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tableContents = self.user?.challenges?.sponsored
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.adjustHeight()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func reloadTableData(){
        self.tableContents = self.user?.challenges?.sponsored
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "createdChallengeCell") as! CreatedChallengeTableViewCell
        
        let currChallenge = user?.challenges?.sponsored![indexPath.row]
        
        cell.challangePrevImage.image = UIImage(named: "Play")
        cell.challengeTitleLbl.text = currChallenge?.title
        cell.challengeRewardLbl.text = "J \(currChallenge?.reward.description ?? "0")"
        
        var completed: Int = 0
        if (currChallenge?.takers != nil) {
            for taker in (currChallenge?.takers)! {
                if taker.completed! {
                    cell.trailerView.backgroundColor = UIColor.blue
                    completed += 1
                }
            }
            let a: Double = Double(completed)
            let b: Double = Double((currChallenge?.takers?.count)!)
            cell.trailerView.alpha = (currChallenge?.takers?.count == 0) ? 0 : CGFloat(a/b)
        } else {
            cell.trailerView.alpha = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedChallenge = (self.user?.challenges?.sponsored![indexPath.row])!
        if (selectedChallenge?.takers != nil) {
            for taker in (selectedChallenge?.takers)! {
                if taker.completed! {
                    performSegue(withIdentifier: "viewResponseSegue", sender: selectedChallenge)
                    return
                }
            }
        }
        
        performSegue(withIdentifier: "createdToWatchSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastitem = tableContents!.count - 1
        
        if (indexPath.row == lastitem) {
            //TODO: loadMoreChallenges()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var hasCompleted = false
        let currentChallenge = user?.challenges?.sponsored![indexPath.row]
        if (currentChallenge?.takers != nil) {
            for taker in currentChallenge!.takers! {
                if (taker.accepted)! {
                    hasCompleted = true
                    break
                }
            }
        }
        
        if (hasCompleted) {
            let modifyAction = UIContextualAction(style: .normal, title:  "View Responses", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.performSegue(withIdentifier: "viewResponseSegue", sender: currentChallenge)
                success(true)
            })
            modifyAction.backgroundColor = .blue
            
            return UISwipeActionsConfiguration(actions: [modifyAction])
        }
        
        return nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createdToWatchSegue") {
            let controller = segue.destination as! ViewChallengeViewController
            controller.viewType = "SPONSORED"
            controller.user = self.user
            controller.challengeQueue = Queue(elements: [self.selectedChallenge!])
            controller.navigationItem.hidesBackButton = false
        }
        
        if (segue.identifier == "viewResponseSegue") {
            let controller = segue.destination as! ViewAllResponsesController
            let selected = sender as! ChallengeDetails
            controller.takers = selected.takers
            controller.user = self.user
            controller.challenge = selected
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
    
    func collapseView() {
        self.tableContents?.removeAll()
        self.reloadTableData()
    }
    
    func expandView() {
        self.tableContents = self.user?.challenges?.sponsored
        self.reloadTableData()
    }

}
