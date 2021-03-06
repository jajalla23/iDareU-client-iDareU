//
//  SelectSponsorTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/2/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SelectSponsorTableViewController: UITableViewController {
    
    var user: User?
    var allFriends: [User]?
    var challengeToBeSetup: ChallengeDetails?
    
    var selectedFriend: User?
    private var checkBoxes: [SelectUserCheckBox] = []
    private var meCheckbox: SelectUserCheckBox?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return self.allFriends?.count ?? 0
        }        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCell", for: indexPath) as! SelectTakerTVCell
        cell.cellCheckbox.addTarget(self, action: #selector(self.cellBoxChanged(_:)), for: .touchDown);
        
        if (indexPath.section == 0) {
            cell.friendUsernameLbl.text = "I"
            cell.cellCheckbox.isCommunity = true
            self.meCheckbox = cell.cellCheckbox
            
            if (self.selectedFriend == nil) {
                cell.cellCheckbox.isChecked = true
            }
        } else {
            let current_friend = self.allFriends![indexPath.row]
            
            cell.cellCheckbox.friend = current_friend
            cell.cellCheckbox.isCommunity = false
            cell.friendUsernameLbl.text = current_friend.display_name

            let selected_friend_id = self.selectedFriend?._id ?? "-1"
            
            if (current_friend._id != selected_friend_id) {
                cell.cellCheckbox.isChecked = false
            } else {
                cell.cellCheckbox.isChecked = true
            }

            self.checkBoxes.append(cell.cellCheckbox)
        }

        return cell
    }
 
    @IBAction func doneTapped(_ sender: Any) {
        //print(self.checkedFriends?.count ?? "no friends checked")
        performSegue(withIdentifier: "unwindToSetupFromSponsor", sender: sender)
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    @objc func cellBoxChanged(_ sender: SelectUserCheckBox) {
        //button checking happens after cellboxchanged completes
        if (!sender.isChecked) {    //checkbox will be checked
            for checkbox in self.checkBoxes {
                if (checkbox != sender) {
                    checkbox.isChecked = false
                }
            }
            
            if (!sender.isCommunity) {
                self.selectedFriend = sender.friend!
                self.meCheckbox?.isChecked = false
            }
        } else {    //cellbox will be unchecked
            if (sender.friend?._id == self.selectedFriend?._id) {
                self.meCheckbox?.isChecked = true
            }
        }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToSetupFromSponsor") {
            let controller = segue.destination as! SetupChallengeViewController

            if (self.meCheckbox!.isChecked) {
                controller.sponsorBtn.setTitle("I", for: UIControlState.normal)
                controller.dareLbl.text = " DARE "
                
                controller.takerBtn.isEnabled = true
                controller.takerBtn.setTitle("YOU", for: UIControlState.normal)
                controller.takerBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
                
                controller.challenge?.addSponsor(user: self.user!, reward: self.challengeToBeSetup!.reward)
                controller.sponsors = []
            }
            else {
                //sponsor is not user
                controller.challenge?.removeAllTakers()
                controller.dareLbl.text = " DARES "
                controller.takerBtn.setTitle("ME", for: UIControlState.normal)
                controller.takerBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                controller.takerBtn.isEnabled = false
                
                let friend_username = (self.selectedFriend?.identification?.username ?? self.selectedFriend?.personalDetails?.name?.first ?? self.selectedFriend?.identification?.email)
                controller.sponsorBtn.setTitle(friend_username, for: UIControlState.normal)
                controller.sponsors?.append(self.selectedFriend!)
                
            }

        }
    }

}
