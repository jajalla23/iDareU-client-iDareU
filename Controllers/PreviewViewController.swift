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

        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        */
        self.setupViewOrigHeight = self.setupChallengeView.frame.height
        self.setupViewOriginY = self.setupChallengeView.frame.origin.y
        self.previewImg.image = self.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setupBtnTapped(_ sender: Any) {
        if (isSetupShown) {
            //hide
            /*UIView.animate(withDuration: 0.7, animations: {
                self.setupChallengeView.frame.origin.y = 0.0
                
                //self.setupChallengeView.frame =  CGRect(x: self.setupChallengeView.frame.origin.x, y: 0.0, width: self.setupChallengeView.frame.width, height: 0.0)
                self.view.layoutIfNeeded()
            })*/
            self.toggleSetupBtn.frame.origin.y += self.setupViewOrigHeight!
            self.toggleSetupBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0.0))

        } else {
            //show
            /*UIView.animate(withDuration: 0.7, animations: {
                self.setupChallengeView.frame.origin.y = self.setupViewOriginY!

                //self.setupChallengeView.frame =  CGRect(x: self.setupChallengeView.frame.origin.x, y: self.setupViewOriginY!, width: self.setupChallengeView.frame.width, height: self.setupViewOrigHeight!)
                self.view.layoutIfNeeded()
            })*/
            self.toggleSetupBtn.frame.origin.y -= self.setupViewOrigHeight!
            self.toggleSetupBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        
        self.setupChallengeView.isHidden = !self.setupChallengeView.isHidden
        self.isSetupShown = !self.isSetupShown
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
            controller.image = self.image
        }
    }
}
