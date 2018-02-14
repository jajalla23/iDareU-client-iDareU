//
//  PendingChallengesViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PendingChallengesViewController: MeGenericViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    public static let scrollViewMaxHeight: CGFloat = CGFloat(80 * 5) //row height x number of cells
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self

        self.adjustHeight()
        self.scrollView.setNeedsDisplay()

        //NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "reloadPendingChallengeView"), object: nil)
    }
    
    public func reloadTableData(){
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.adjustHeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user?.challenges?.pending?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingChallengeCell") as! PendingChallengeTableViewCell
        
        let currChallenge = user?.challenges?.pending![indexPath.row]
        
        cell.challangePrevImage.image = UIImage(named: "Play")
        cell.challengeTitleLbl.text = currChallenge?.title
        cell.challengeRewardLbl.text = "J \(currChallenge?.reward.description ?? "0")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challenge: ChallengeDetails = (self.user?.challenges?.pending![indexPath.row])!
        print(challenge._id ?? "unknown")
        performSegue(withIdentifier: "pendingToWatchSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Reject", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.user?.challenges?.pending!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.adjustHeight()
            success(true)
        })
        //closeAction.image = UIImage(named: "second")
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Accept", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Challenge Accepted")
            success(true)
        })
        //modifyAction.image = UIImage(named: "Play")
        modifyAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    private func adjustHeight() {
        let tableViewHeight: CGFloat = CGFloat(80 * (self.user?.challenges?.pending?.count ?? 0))
        self.tableView.frame.size.height = tableViewHeight
        
        self.scrollView.contentSize = CGSize(width: self.tableView.frame.size.width, height: tableViewHeight)
        
        if (tableViewHeight > PendingChallengesViewController.scrollViewMaxHeight) {
            self.scrollView.frame.size.height = PendingChallengesViewController.scrollViewMaxHeight
        } else {
            self.scrollView.frame.size.height = tableViewHeight
        }
        
        self.view.layoutIfNeeded()
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
