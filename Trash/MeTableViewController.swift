//
//  MeTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/6/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var user: User? = nil

    @IBOutlet weak var statusViewCell: CollapsibleTableViewCell!
    
    private var sections = [MeSections(name: "My Status", collapsed: false, numOfRows: 1), MeSections(name: "My Pending Challenges", collapsed: true, numOfRows: 1), MeSections(name: "My Completed Challenges", collapsed: true, numOfRows: 1), MeSections(name: "My Created Challenges", collapsed: true, numOfRows: 3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Auto resizing the height of the cell
        //tableView.estimatedRowHeight = 500.0
        //tableView.rowHeight = UITableViewAutomaticDimension

        /*statusViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")*/
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
        
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let routerController: RouterTabBarController = self.tabBarController as! RouterTabBarController
        let meViewController = segue.destination as? MeParentViewController
        meViewController?.user = routerController.user
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
// MARK: - View Controller DataSource and Delegate
//

extension MeTableViewController {
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sections[section].collapsed ? 0 : 1
        return sections[section].collapsed ? 0 : sections[section].numberOfRows
    }
    
    //row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section) {
        case 0:
            tableView.estimatedRowHeight = 500.0
            tableView.rowHeight = UITableViewAutomaticDimension
            return 500

        default:
            return UITableViewAutomaticDimension
        }
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.textColor = UIColor.white
        header.arrowLabel.text = ">"
        header.arrowLabel.textColor = UIColor.black
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainMyChallengesCell", for: indexPath as IndexPath) as! CollapsibleTableViewCell
            
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "mainStatusViewCell", for: indexPath as IndexPath) as! CollapsibleTableViewCell
        }
    }
    
}

//
// MARK: - Section Header Delegate
//
extension MeTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        if (!collapsed) {
            //super.tableView(self.tableView, numberOfRowsInSection: section)
        }
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
}
