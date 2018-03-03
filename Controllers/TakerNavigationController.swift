//
//  TakerNavigationController
//  iDareU
//
//  Created by Jan Jajalla on 3/3/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class TakerNavigationController: UINavigationController {
    var allFriends: [User]?
    var selectedFriends: [String: User]?
    var isCommunityChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
