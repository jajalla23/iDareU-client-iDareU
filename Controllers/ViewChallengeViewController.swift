//
//  ViewChallengeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/10/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewChallengeViewController: UIViewController {

    var challenge: ChallengeDetails?
    
    private var divisor: CGFloat?
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var challengeInfoView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        challengeInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.divisor = (view.frame.width / 2) / 0.61
        
        let controller = self.navigationController as! ViewChallengeNavigationController
        
        self.challenge = controller.getChallenge()
        self.navigationItem.title = self.challenge?.title
        self.navigationItem.hidesBackButton = false
        
        if (controller.viewType == "PENDING") {
            self.panGestureRecognizer.isEnabled = true
            let _ = controller.popChallenge()
        }
        
        do {
            let imageData = try Server.fetchMedia(mediaName: self.challenge!.media!.fileName, mediaType: self.challenge!.media!.type)
            
            self.imageView.image = UIImage(data: imageData!, scale: 1.0)
            self.imageView.contentMode = .scaleAspectFit
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "challengeLabelSegue") {
            let controller = segue.destination as! ViewChallengeLabelController
            let naviController = self.navigationController as! ViewChallengeNavigationController
            controller.challenge = naviController.getChallenge()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        challengeInfoView.isHidden = !challengeInfoView.isHidden
    }
    
    @IBAction func rightBarItemTapped(_ sender: Any) {
        print("tapped")
    }
    
    @IBAction func panHandler(_ sender: UIPanGestureRecognizer) {
        let container = imageContainerView!
        let point = sender.translation(in: view)
        container.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let xFromCenter = container.center.x - view.center.x
        let scale = min(100/abs(xFromCenter), 1)
        container.transform = CGAffineTransform(rotationAngle: xFromCenter/self.divisor!).scaledBy(x: scale, y: scale)
        
        if (xFromCenter > 0) {
            actionImageView.image = #imageLiteral(resourceName: "accept")
        } else {
            actionImageView.image = #imageLiteral(resourceName: "reject")
        }
        
        self.actionImageView.alpha = abs(xFromCenter) / self.view.center.x
        actionImageView.backgroundColor = UIColor.white

        if (sender.state == UIGestureRecognizerState.ended) {
            if (container.center.x < 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x - 200, y: container.center.y + 75)
                })
                rejectChallenge()
                self.reloadChallengeDetails()
            }
            
            if (container.center.x > self.view.frame.width - 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x + 200, y: container.center.y + 75)
                })
                acceptChallenge()
                self.reloadChallengeDetails()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                container.center = self.view.center
                container.transform = CGAffineTransform.identity

                self.actionImageView.alpha = 0
            })
        }
        
    }
    
    private func rejectChallenge() {
        do {
            let controller = self.navigationController as! ViewChallengeNavigationController
            try Server.rejectChallenge(user_id: controller.user!._id!, challenge_id: self.challenge!._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
        }
        
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
    }
    
    private func acceptChallenge() {
        do {
            let controller = self.navigationController as! ViewChallengeNavigationController
            try Server.acceptChallenge(user_id: controller.user!._id!, challenge_id: self.challenge!._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
        }
    }
    
    private func reloadChallengeDetails() {
        let controller = self.navigationController as! ViewChallengeNavigationController
        if (controller.isChallengeListEmpty()) {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.challenge = controller.popChallenge()
        self.navigationItem.title = self.challenge?.title
        
        do {
            let imageData = try Server.fetchMedia(mediaName: self.challenge!.media!.fileName, mediaType: self.challenge!.media!.type)
            
            self.imageView.image = UIImage(data: imageData!, scale: 1.0)
            self.imageView.contentMode = .scaleAspectFit
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let challengeLabelCont = self.childViewControllers.first as? ViewChallengeLabelController {
            challengeLabelCont.challenge = self.challenge
            challengeLabelCont.viewDidLoad()
            challengeInfoView.setNeedsLayout()
            challengeInfoView.layoutIfNeeded()
        }
        
    }
}

