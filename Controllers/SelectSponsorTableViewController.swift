//
//  SelectSponsorTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/2/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SelectSponsorTableViewController: UITableViewController {
    var allFriends: [User]?
    private var selectedFriends: [String: User]?
    private var isMeChecked: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedFriends = [String: User]()
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
            cell.cellCheckbox.isChecked = true
        } else {
            cell.cellCheckbox.friend = self.allFriends![indexPath.row]
            cell.cellCheckbox.isCommunity = false
            cell.cellCheckbox.isChecked = false
            cell.friendUsernameLbl.text = (self.allFriends![indexPath.row].username ?? "")
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

    @objc func cellBoxChanged(_ sender: SelectTakerCheckBox) {
        let friend: User? = sender.friend
        
        //button checking happens after this function
        if (!sender.isChecked) {
            if (sender.isCommunity) {
                self.isMeChecked = true
            } else {
                self.selectedFriends![friend!._id!] = sender.friend!
            }
        } else {
            if (sender.isCommunity) {
                self.isMeChecked = false
            } else {
                self.selectedFriends!.removeValue(forKey: friend!._id!)
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

            if (self.isMeChecked) {
                controller.sponsorBtn.setTitle("I", for: UIControlState.normal)
                
                controller.takerBtn.isEnabled = true
                controller.takerBtn.setTitle("YOU", for: UIControlState.normal)
                controller.takerBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
            }
            else {
                controller.challenge?.removeAllTakers()
                controller.takerBtn.setTitle("ME", for: UIControlState.normal)
                controller.takerBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
                controller.takerBtn.isEnabled = false
                controller.sponsorBtn.setTitle("Others", for: UIControlState.normal)
            }

        }
    }

}
