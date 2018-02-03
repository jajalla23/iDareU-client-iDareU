//
//  PreviewViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/31/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    public var user: User?
    public var image: UIImage?
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var setupChallengeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        */
        self.previewImg.image = self.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showTxtBtnTapped(_ sender: Any) {
        self.setupChallengeView.isHidden = !self.setupChallengeView.isHidden
    }
    
    @IBAction func closeView(_ sender: Any) {
        performSegue(withIdentifier: "previewUnwindSegue", sender: sender)
    }
    
    @IBAction func sendChallengeTapped(_ sender: Any) {
        performSegue(withIdentifier: "sendChallengeSegue", sender: sender)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "setupEmbedSegue") {
            guard let controller = segue.destination as? SetupChallengeViewController else {
                return
            }
            controller.user = self.user
        }
    }

}
