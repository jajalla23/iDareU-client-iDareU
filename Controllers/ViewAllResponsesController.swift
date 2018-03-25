//
//  ViewAllResponsesController.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/24/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ViewAllResponsesController: UICollectionViewController {

    var user: User?
    var takers: [Taker]?
    
    private var cellSize: CGFloat?
    @IBOutlet var responseCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(ViewResponseViewCell.self, forCellWithReuseIdentifier: "viewResponseCell")

        // Do any additional setup after loading the view.
        cellSize = UIScreen.main.bounds.width/3 - 2

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellSize!, height: cellSize!)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        responseCollView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return takers?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewResponseCell", for: indexPath) as! ViewResponseViewCell
    
        // Configure the cell
        let current = takers![indexPath.row]
        
        if (current.completed!) {
            do {
                let imageData = try Server.fetchMedia(mediaName: (current.media?.fileName)!, mediaType: (current.media?.type)!)
                cell.responseImage.image = UIImage(data: imageData!, scale: 1.0)
                cell.responseImage.contentMode = .scaleAspectFit
            } catch let error {
                print(error.localizedDescription)
                let taker_name = current.user.display_name ?? user?.friends![(current.user._id)!]?.display_name ?? "? ?"
                cell.responseImage.image = ImageGenerator.imageWith(name: taker_name, width: (cellSize ?? 80), height: (cellSize ?? 120), fontSize: 50)
            }
        } else {
            let taker_name = current.user.display_name ?? user?.friends![(current.user._id)!]?.display_name ?? "? ?"
            cell.responseImage.image = ImageGenerator.imageWith(name: taker_name, width: (cellSize ?? 80), height: (cellSize ?? 120), fontSize: 50)
        }
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize.init(width: (cellSize ?? 120), height: (cellSize ?? 120))
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
