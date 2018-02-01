//
//  SendChallengeTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/31/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SendChallengeTableViewController: UITableViewController {
    var user: User?
    private var isCommunityChecked: Bool = false
    private var checkedFriends: Array<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkedFriends = []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return 1
        }
        return self.user?.friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! SendChallengeTVCell

        if (indexPath.section == 0) {
            cell.cellCheckbox.isCommunity = true
            cell.friendUsernameLbl.text = "Community"
        } else {
            cell.cellCheckbox.friend = self.user?.friends![indexPath.row]
            cell.cellCheckbox.friendNumber = indexPath.row
            cell.friendUsernameLbl.text = (self.user?.friends![indexPath.row].username ?? "")
        }
        return cell

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendTapped(_ sender: Any) {
        print(self.checkedFriends?.count ?? "no friends checked")
        performSegue(withIdentifier: "sendChallToRouterSegue", sender: sender)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cellBoxChecked(_ sender: SendChallengeCheckBox) {
        if (sender.isChecked) {
            if (sender.isCommunity) {
                self.isCommunityChecked = true
            } else {
                self.checkedFriends![sender.friendNumber!] = sender.friend!
            }
        } else {
            if (sender.isCommunity) {
                self.isCommunityChecked = false
            } else {
                self.checkedFriends?.remove(at: sender.friendNumber!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sendChallToRouterSegue") {
            let routerController = segue.destination as! RouterTabBarController
            routerController.user = self.user
        }
    }

}
