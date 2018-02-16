//
//  PreviewViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/31/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, SetupChallengeDelegate {
    
    public var user: User?
    public var image: UIImage?
    
    private var isSetupShown: Bool = false
    private var setupViewOrigHeight: CGFloat?
    private var setupViewOriginY: CGFloat?
    
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var setupChallengeView: UIView!
    @IBOutlet weak var toggleSetupBtn: UIButton!
    @IBOutlet weak var challengeDescTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.setupViewOrigHeight = self.setupChallengeView.frame.height
        self.setupViewOriginY = self.setupChallengeView.frame.origin.y
        self.previewImg.image = self.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setupBtnTapped(_ sender: Any) {
        self.toggleSetupBtn.isHidden = true
        self.setupChallengeView.isHidden = false
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
            controller.delegate = self
            controller.user = self.user
            controller.image = self.image
        }
    }
    
    func closeSetupView(setupChallengeController: SetupChallengeViewController) {
        self.toggleSetupBtn.isHidden = false
        self.setupChallengeView.isHidden = true
    }
}
