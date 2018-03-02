//
//  PendingChallengesViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PendingChallengesViewController: MeGenericViewController, UITableViewDataSource, UITableViewDelegate  {
    
    private var selectedChallenge: ChallengeDetails?
    private var selectedIndex: Int?
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
        
        if let i = currChallenge?.takers!.index(where: {$0.user._id == self.user?._id}) {
            if (currChallenge?.takers?[i].accepted ?? false) {
                cell.layer.borderWidth = 3.0
                cell.layer.borderColor = UIColor.green.cgColor
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challenge: ChallengeDetails = (self.user?.challenges?.pending![indexPath.row])!
        self.selectedChallenge = challenge
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "pendingToWatchSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Reject", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.rejectChallenge(challenge: (self.user?.challenges?.pending![indexPath.row])!)

            self.user?.challenges?.pending!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            DispatchQueue.main.async{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
            }
            
            success(true)
        })
        //closeAction.image = UIImage(named: "second")
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Accept", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.acceptChallenge(challenge: (self.user?.challenges?.pending![indexPath.row])!, cell: tableView.cellForRow(at: indexPath)!)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pendingToWatchSegue") {
            let controller = segue.destination as! ViewChallengeNavigationController
            controller.user = self.user
            
            let sub_array = self.user?.challenges?.pending![self.selectedIndex!...]
            controller.challengeList = Array(sub_array!)
            
            if (self.selectedIndex != 0) {
                let temp = self.user?.challenges?.pending![0...self.selectedIndex! - 1]
                let temp_array = Array(temp!)
            
                controller.challengeList?.append(contentsOf: temp_array)
            }
            
            controller.viewType = "PENDING"
            
            controller.navigationItem.hidesBackButton = false
        }
    }
    
    private func acceptChallenge(challenge: ChallengeDetails, cell: UITableViewCell) {
        do {
            try Server.acceptChallenge(user_id: self.user!._id!, challenge_id: challenge._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
            return
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
            return
        }
        
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.green.cgColor
    }
    
    private func rejectChallenge(challenge: ChallengeDetails) {
        do {
            try Server.rejectChallenge(user_id: self.user!._id!, challenge_id: challenge._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
    }

}
