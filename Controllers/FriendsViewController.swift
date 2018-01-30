//
//  FriendsViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendFeedTableView: UITableView!
    
    var user: User? = nil
    var friendFeeds: [FriendFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        friendFeedTableView.delegate = self
        friendFeedTableView.dataSource = self
        
        let routerController: RouterTabBarController = self.tabBarController as! RouterTabBarController
        self.user = routerController.user

        friendFeeds = Server.getFriendFeedData(userId: self.user!.id!)

        // Do any additional setup after loading the view.
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
            self.performSegue(withIdentifier: "doubleDownSegue", sender: ac)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
