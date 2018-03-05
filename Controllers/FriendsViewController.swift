//
//  FriendsViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class FriendsViewController: GenericUIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendFeedTableView: UITableView!
    
    var friendFeeds: [FriendFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        friendFeedTableView.delegate = self
        friendFeedTableView.dataSource = self

        do {
            try friendFeeds = Server.getFriendFeedData(userId: self.user!._id!)
        } catch let error {
            //TODO: catch error
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = friendFeedTableView.dequeueReusableCell(withIdentifier: "friendFeedCell") as! FriendFeedViewCell
        
        let friendActivityText = NSMutableAttributedString()
        let currFriendFeed = friendFeeds[indexPath.row]
        let challengeCompleted: Bool = currFriendFeed.challenge.isCompleted
        
        if (challengeCompleted == true) {
            friendActivityText.bold(currFriendFeed.friendUsername + " ").normal("responded to ").bold(currFriendFeed.ownerUsername + " ").normal("to ").bold(currFriendFeed.challenge.title)
        } else {
            friendActivityText.bold(currFriendFeed.ownerUsername + " ").normal("dared ").bold(currFriendFeed.friendUsername + " ").normal("to ").bold(currFriendFeed.challenge.title)
        }
        
        cell.challengeImgPreview.image = UIImage(named: currFriendFeed.challenge.imagePreviewURL ?? "Play")
        cell.challengeRewardLbl.text = "J \(currFriendFeed.challenge.reward.description)"
        cell.friendsActivityLbl.attributedText = friendActivityText
        
        cell.friendFeed = currFriendFeed
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.friendFeeds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            success(true)
        })
        //closeAction.image = UIImage(named: "second")
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Double Down!", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Double Down")
            self.performSegue(withIdentifier: "doubleDownSegue", sender: self.friendFeeds[indexPath.row])
            success(true)
        })
        //modifyAction.image = UIImage(named: "doubledown")
        modifyAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriendFeed: FriendFeed = self.friendFeeds[indexPath.row]
        print(selectedFriendFeed.challenge.title)
        
        performSegue(withIdentifier: "friendToWatchSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "doubleDownSegue") {
            //let selectedIndex = self.friendFeedTableView.indexPath(for: sender as! UITableViewCell)
            let friendFeed = sender as! FriendFeed
            let controller = segue.destination as? UpdateChallengeRewardController
            controller?.user = self.user
            //controller?.challenge = friendFeed.challenge
            controller?.challenge_id = friendFeed.challenge.id
            controller?.challenge_reward = friendFeed.challenge.reward
            controller?.challenge_title = friendFeed.challenge.title
            
            controller?.viewTitle = "Double Down!"
            controller?.viewAction = "Add how much?"
            
        } else {
            let controller = segue.destination as? GenericUIViewController
            controller?.user = self.user
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
    
    @IBAction func edgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        let tabController = self.tabBarController as! RouterTabBarController

        if (sender.edges == .left) {
            tabController.selectedIndex = 1
        } else {
            tabController.selectedIndex = 3
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 17)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
