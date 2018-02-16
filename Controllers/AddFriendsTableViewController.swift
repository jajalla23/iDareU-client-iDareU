//
//  AddFriendsTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class AddFriendsTableViewController: UITableViewController {
    var delegate: AddFriendsDelegate?
    
    var user_id: String?
    var potential_friends: [User]?
    var selectedFriends: [Int: User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(sender:)), for: UIControlEvents.valueChanged)


        let naviController = self.navigationController as! ProfileNaviController
        self.user_id = naviController.user?._id
        
        do {
            self.potential_friends = try Server.getOtherUsers(user_id: naviController.user!._id!, friends: Array(naviController.user!.friends!.values))
        } catch let cError as CustomError {
            print(cError.description)
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.selectedFriends = [Int: User]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.potential_friends?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendResultCell", for: indexPath) as! FriendsTVCell

        let friend = self.potential_friends![indexPath.row]
        cell.friendLbl.text = friend.display_name
        cell.checkBox.isChecked = false
        cell.onCheckBoxToggled = {
            self.updateSelectedFriends(cell: cell, indexPath: indexPath)
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendsTVCell
        self.updateSelectedFriends(cell: cell, indexPath: indexPath)
        cell.checkBox.isChecked = !cell.checkBox.isChecked
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */
    
    @IBAction func addFriendsBtnTapped(_ sender: Any) {
        if (self.selectedFriends?.count == 0) {
            return
        }
        
        self.potential_friends! = self.potential_friends!
            .enumerated()
            .filter { !Array(self.selectedFriends!.keys).contains($0.offset) }
            .map { $0.element }
        
        do {
            try Server.addFriends(user_id: self.user_id!, friends: Array(selectedFriends!.values))
            self.delegate?.friendsUpdated(addFriendsController: self)
            self.tableView.reloadData()
            self.selectedFriends?.removeAll()

        } catch let error {
            
        }

    }
    
    private func updateSelectedFriends(cell: FriendsTVCell, indexPath: IndexPath) {
        if (cell.checkBox.isChecked) {
            //will be unchecked
            self.selectedFriends?.removeValue(forKey: indexPath.row)
        } else {
            //will be checked
            self.selectedFriends?[indexPath.row] = self.potential_friends![indexPath.row]
        }
    }
    
    @objc func handleRefresh(sender: AnyObject) {
        do {
            let naviController = self.navigationController as! ProfileNaviController
            self.potential_friends = try Server.getOtherUsers(user_id: naviController.user!._id!, friends: Array(naviController.user!.friends!.values))
        } catch let cError as CustomError {
            print(cError.description)
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.selectedFriends = [Int: User]()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}

protocol AddFriendsDelegate {
    func friendsUpdated(addFriendsController: AddFriendsTableViewController)
}
