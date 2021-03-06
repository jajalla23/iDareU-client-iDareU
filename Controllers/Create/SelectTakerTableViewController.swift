//
//  SendChallengeTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/31/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SelectTakerTableViewController: UITableViewController {
    var delegate: SelectTakerDelegate?
    
    var allFriends: [User]?
    var selectedFriends: [String: User]?
    var isCommunityChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let naviController = navigationController as! TakerNavigationController
        self.delegate = naviController.takerDelegate
        self.allFriends = naviController.allFriends
        self.selectedFriends = naviController.selectedFriends
        self.isCommunityChecked = naviController.isCommunityChecked
        
        if (self.selectedFriends == nil) {
            self.selectedFriends = [String: User]()
        }
        
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
        } else {
            return self.allFriends?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! SelectTakerTVCell
        cell.cellCheckbox.addTarget(self, action: #selector(self.cellBoxChanged(_:)), for: .touchDown);

        if (indexPath.section == 0) {
            cell.cellCheckbox.isCommunity = true
            cell.friendUsernameLbl.text = "Anyone"
            
            if (self.isCommunityChecked) {
                cell.cellCheckbox.isChecked = true
            } else {
                cell.cellCheckbox.isChecked = false
            }
            
        } else {
            let current_friend = self.allFriends![indexPath.row]
            let selected_friend = self.selectedFriends![current_friend._id!] ?? nil
            
            cell.cellCheckbox.friend = current_friend
            cell.friendUsernameLbl.text = current_friend.display_name
            
            if (selected_friend?._id != current_friend._id) {
                cell.cellCheckbox.isChecked = false
            } else {
                cell.cellCheckbox.isChecked = true
            }
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
    
    @IBAction func doneTapped(_ sender: Any) {
        //performSegue(withIdentifier: "setupUnwindSegue", sender: sender)
        delegate?.selectionDone(selectTakerController: self)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cellBoxChanged(_ sender: SelectUserCheckBox) {
        let friend: User? = sender.friend
        
        //button checking happens after this function
        if (!sender.isChecked) {
            if (sender.isCommunity) {
                self.isCommunityChecked = true
            } else {
                self.selectedFriends![friend!._id!] = sender.friend!
            }
        } else {
            if (sender.isCommunity) {
                self.isCommunityChecked = false
            } else {
                self.selectedFriends!.removeValue(forKey: friend!._id!)
            }
        }
    }
}

protocol SelectTakerDelegate {
    func selectionDone(selectTakerController: SelectTakerTableViewController)
}
