//
//  CameraToolsTableViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/13/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class CameraToolsTableViewController: UITableViewController {
    var delegate: CameraToolsControllerDelegate?
    
    @IBOutlet weak var controlCell: UITableViewCell!
    @IBOutlet weak var cameraRotateCell: UITableViewCell!
    @IBOutlet weak var cameraFlashCell: UITableViewCell!
    
    @IBOutlet weak var cameraRotateBtn: UIButton!
    @IBOutlet weak var cameraFlashBtn: UIButton!
    
    private var rotateCellHeight: CGFloat?
    private var flashCellHeight: CGFloat?
    private var isExpanded: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        controlCell.selectionStyle = UITableViewCellSelectionStyle.none
        controlCell.backgroundColor = UIColor.clear
        cameraRotateCell.selectionStyle = UITableViewCellSelectionStyle.none
        cameraRotateCell.backgroundColor = UIColor.clear
        cameraFlashCell.selectionStyle = UITableViewCellSelectionStyle.none
        cameraFlashCell.backgroundColor = UIColor.clear
        
        rotateCellHeight = cameraRotateCell.contentView.frame.height
        flashCellHeight = cameraFlashCell.contentView.frame.height
        
        self.view.backgroundColor = UIColor.clear
        
        #if !SIMULATOR
            self.cameraFlashBtn.isEnabled = true
            self.cameraRotateBtn.isEnabled = true
        #endif

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
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    @IBAction func controlBtnTapped(_ sender: Any) {
        //let camCell = self.cameraFlashCell!
        if (isExpanded) {
            /*UIView.animate(withDuration: 0.7, animations: {
                camCell.contentView.frame = CGRect(x: camCell.contentView.frame.origin.x, y: camCell.contentView.frame.origin.y, width: camCell.contentView.frame.width, height: 0.0)
                self.view.layoutIfNeeded()
            })*/
        }
        
        isExpanded = !isExpanded
    }
    
    @IBAction func cameraRotateBtnTapped(_ sender: Any) {
        self.delegate?.cameraRotateBtnTapped(cameraToolsController: self)
    }
    
    @IBAction func cameraFlashBtnTapped(_ sender: Any) {
        self.delegate?.cameraFlashBtnTapped(cameraToolsController: self)
    }
    
}

protocol CameraToolsControllerDelegate {
    func cameraRotateBtnTapped(cameraToolsController: CameraToolsTableViewController)
    func cameraFlashBtnTapped(cameraToolsController: CameraToolsTableViewController)

}
