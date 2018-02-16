//
//  MyFriendsTableViewController
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MyFriendsTableViewController: UITableViewController, UISearchBarDelegate {
    var friends: [String: User]?
    var friendsKeys: [String]?
    
    private var filteredList: [User]?
    
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(sender:)), for: UIControlEvents.valueChanged)
        
        let naviController = self.navigationController as! ProfileNaviController
        self.friends = naviController.user?.friends
        self.friendsKeys = Array(self.friends!.keys)
        
        searchBar.delegate = self
        //searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendsTVCell

        let friend = self.friends![friendsKeys![indexPath.row]]
        cell.friendLbl.text = friend?.display_name ?? friend?._id ?? "<NO NAME>"
        //cell.friendImgView.image = UIImage    //friends![indexPath.row].media?.fileName

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
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title:  "Remove", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.friends?.removeValue(forKey: self.friendsKeys![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            success(true)
        })
        closeAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addFriendsSegue") {
            let controller = segue.destination as! AddFriendsTableViewController
            controller.delegate = self
        }
    }
    
    @IBAction func unwindToMyFriends(segue: UIStoryboardSegue) {
        self.friendsKeys = Array(self.friends!.keys)
        self.tableView.reloadData()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRefresh(sender: AnyObject) {
        do {
            let naviController = self.navigationController as! ProfileNaviController
            let updatedFriends = try Server.getFriends(user_id: naviController.user!._id!)
            
            self.friends = updatedFriends
            self.friendsKeys = Array(updatedFriends.keys)
        } catch let cError as CustomError {
            print(cError.description)
        } catch let error {
            print(error.localizedDescription)
        }

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        /*if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredList = friends.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredNFLTeams = unfilteredNFLTeams
        }
        tableView.reloadData()*/
    }
}

extension MyFriendsTableViewController: AddFriendsDelegate {
    func friendsUpdated(addFriendsController: AddFriendsTableViewController) {
        if let newFriends = addFriendsController.selectedFriends {
            if (!newFriends.isEmpty) {
                let naviController = self.navigationController as! ProfileNaviController

                for (_, friend) in newFriends {
                    naviController.user?.addFriend(friend: friend)
                    self.friends![friend._id!] = friend
                    self.friendsKeys?.append(friend._id!)
                }
                
                DispatchQueue.main.async{
                    let dataDict:[String: User] = ["user": naviController.user!]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshUserData"), object: nil, userInfo: dataDict)
                }
                
                self.tableView.reloadData()
            }
        }
    }

}
