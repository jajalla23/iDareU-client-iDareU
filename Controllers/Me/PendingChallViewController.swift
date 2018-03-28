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
    
    private var selectedChallenge: ChallengeDetails?
    private var selectedIndex: Int?
    private var tableContents: [ChallengeDetails]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.tableContents = self.user?.challenges?.pending
        
        tableView.delegate = self
        tableView.dataSource = self

        self.adjustHeight()
        self.scrollView.setNeedsDisplay()

        //NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: NSNotification.Name(rawValue: "reloadPendingChallengeView"), object: nil)
    }
    
    public func reloadTableData(){
        self.tableContents = self.user?.challenges?.pending
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
        return self.tableContents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingChallengeCell") as! PendingChallengeTableViewCell
        
        let currChallenge = user?.challenges?.pending![indexPath.row]
        
        if let challengePreview = currChallenge?.media?.preview {
            print(challengePreview)
            cell.challengePrevImage.image = UIImage(named: "Play")
        } else {
            cell.challengePrevImage.image = ImageGenerator.imageWith(name: (currChallenge?.sponsor?.display_name ?? "?"))
        }

        cell.challengeTitleLbl.text = currChallenge?.title
        cell.challengeRewardLbl.text = "J \(currChallenge?.reward.description ?? "0")"
        
        if let i = currChallenge?.takers!.index(where: {$0.user._id == self.user?._id}) {
            if (currChallenge?.takers?[i].accepted ?? false) {
                cell.noActionIndicatorView.backgroundColor = UIColor.clear
                cell.acceptedIndicatorView.backgroundColor = UIColor.green
            } else {
                cell.noActionIndicatorView.backgroundColor = UIColor.clear
                cell.acceptedIndicatorView.backgroundColor = UIColor.orange
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
        let closeAction = UIContextualAction(style: .normal, title:  "Decline", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let result = self.declineChallenge(challenge: (self.user?.challenges?.pending![indexPath.row])!)

            if (result) {
                self.user?.challenges?.pending!.remove(at: indexPath.row)
                self.tableContents?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
                DispatchQueue.main.async{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
                }
                success(true)
            } else {
                success(false)
            }
        })
        //closeAction.image = UIImage(named: "second")
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let cell = tableView.cellForRow(at: indexPath)! as! PendingChallengeTableViewCell
        let currChallenge = self.user?.challenges?.pending![indexPath.row]
        
        var modifyAction: UIContextualAction?
        if let i = currChallenge?.takers!.index(where: {$0.user._id == self.user?._id}) {
            if (currChallenge?.takers?[i].accepted ?? false) {
                
                modifyAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    
                    self.selectedIndex = indexPath.row
                    self.performSegue(withIdentifier: "cameraSegue", sender: self)
                    success(true)
                })
                modifyAction?.backgroundColor = .blue
                
            } else {
                modifyAction = UIContextualAction(style: .normal, title:  "Accept", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    
                    let result = self.acceptChallenge(challenge: (self.user?.challenges?.pending![indexPath.row])!)
                    
                    if (result) {
                        //cell.noActionIndicatorView.backgroundColor = UIColor.clear
                        cell.acceptedIndicatorView.backgroundColor = UIColor.green
                        success(true)
                    } else {
                        success(false)
                    }
                    
                })
                modifyAction?.backgroundColor = .green
            }
            return UISwipeActionsConfiguration(actions: [modifyAction!])
        }
        
        return nil
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
            let controller = segue.destination as! ViewChallengeViewController
            controller.user = self.user
            controller.viewType = "PENDING"
            controller.delegate = self
            
            var temp_array = Array((self.user?.challenges?.pending![self.selectedIndex!...] ?? []))
            if (self.selectedIndex != 0 && temp_array.count > 0) {
                let temp = self.user?.challenges?.pending![0...self.selectedIndex! - 1]
                temp_array.append(contentsOf: Array(temp!))
            }
            
            controller.challengeQueue = Queue(elements: temp_array)
        }
        
        if (segue.identifier == "cameraSegue") {
            let controller = segue.destination as? CameraController
            let temp_challenge = self.user?.challenges?.pending![self.selectedIndex!]
            controller?.challenge = temp_challenge
            controller?.user = self.user
            
            for taker in (temp_challenge?.takers)! {
                if (taker.user._id == controller?.user?._id) {
                    controller?.taker = taker
                    break
                }
            }
        }
    }
    
    private func acceptChallenge(challenge: ChallengeDetails) -> Bool {
        do {
            try Server.acceptChallenge(user_id: self.user!._id!, challenge_id: challenge._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
            return false
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
            return false
        }
        
        return true
    }
    
    private func declineChallenge(challenge: ChallengeDetails) -> Bool {
        do {
            try Server.declineChallenge(user_id: self.user!._id!, challenge_id: challenge._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
            return false
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
            return false
        }

        return true
    }

    func collapseView() {
        self.tableContents?.removeAll()
        self.reloadTableData()
    }
    
    func expandView() {
        self.tableContents = self.user?.challenges?.pending
        self.reloadTableData()
    }
}

extension PendingChallengesViewController: ViewChallengeDelegate {
    func rejectChallenge(challenge: ChallengeDetails, challengeIndex challengeRow: Int) {
        print("reject view")
        var index = selectedIndex! + challengeRow
        if (index > tableContents!.count) {
            index = index - tableContents!.count
        }
        
        //self.user?.challenges?.pending!.remove(at: index)
        //self.tableContents?.remove(at: index)
        
        //let indexPath = IndexPath.init(row: index, section: 0)
        //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        tableView.reloadData()
    }
    
    func acceptChallenge(challenge: ChallengeDetails, challengeIndex challengeRow: Int) {
        print("accept view")

        var index = selectedIndex! + challengeRow
        if (index > tableContents!.count) {
            index = index - tableContents!.count
        }
        
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! PendingChallengeTableViewCell
        cell.acceptedIndicatorView.backgroundColor = UIColor.green
        cell.layoutIfNeeded()
        tableView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
}
