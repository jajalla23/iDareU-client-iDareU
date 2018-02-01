//
//  CommunityViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/6/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class CommunityViewController: GenericUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var communityTableView: UITableView!
    
    var data : [[String]] = [["ACT LIKE A G", "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis.", "Play"],["ACT LIKE A G", "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis.", "Play"],["ACT LIKE A G", "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis.", "Play"],["ACT LIKE A G", "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis.", "Play"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        print(NSStringFromClass(self.classForCoder) + " : " + (self.user?.id ?? "user not set"))

        communityTableView.delegate = self
        communityTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = communityTableView.dequeueReusableCell(withIdentifier: "challengeCell") as! CommunityViewCell
        
        cell.challengeTitleLbl.text = String(indexPath.row + 1) + " ACT LIKE A G"
        cell.challengeDescLbl.text = "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis."
        cell.challengeImgPreview.image = UIImage(named: "Play")
        
        //cell.layer.cornerRadius = cell.frame.height / 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastitem = data.count - 1
        
        if (indexPath.row == lastitem) {
            loadMoreChallenges()
        }
    }
    
    private func loadMoreChallenges() {
        for _i in 1 ..< 5 {
            //let lastitem = data.last!
            if _i == _i { print() }
            let newItem : [String] = ["ACT LIKE A G", "Lorem ipsum dolor sit amet, ex alia mediocritatem usu. In laudem propriae duo, doctus aliquid praesent ad pro, detraxit sapientem et vis.", "Play"]
            data.append(newItem)
        }
        
        communityTableView.reloadData()
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
