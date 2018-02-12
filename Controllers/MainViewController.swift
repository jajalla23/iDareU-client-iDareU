//
//  MainViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/10/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //@IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //imageView.image = UIImage(named: "process")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func testBtnPressed(_ sender: Any) {
        print(UIImageJPEGRepresentation((imageView.image)!, 1)?.count)
        let compressed = imageView.image?.compressJPEGImage()
        do {
            let gzipped = try compressed!.gzipped(level: .bestCompression)
            let unzip = try gzipped.gunzipped()
            imageView.image = UIImage(data:unzip,scale:1.0)
            print(UIImageJPEGRepresentation((imageView.image)!, 1)?.count)
        } catch let error {
            
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
