//
//  ViewChallenge.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/25/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewPendingChallengeController: UIViewController {
    
    var naviController: ViewChallengeNavigationController?
    var delegate: ViewChallengeDelegate?
    var challenge: ChallengeDetails?
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var challengeInfoView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    public var swipeRightImage: UIImage = #imageLiteral(resourceName: "accept")
    public var swipeLeftImage: UIImage = #imageLiteral(resourceName: "reject")
    
    private var divisor: CGFloat?
    private var challengeIndex: Int = 0
    private var isAccepted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        error_location = "/Controllers/ViewChallengeParent.swift"
        naviController = self.navigationController as! ViewChallengeNavigationController

        self.delegate = naviController.viewChallengeDelegate
        self.challenge = naviController.getChallenge()
        challengeInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.divisor = (view.frame.width / 2) / 0.61
        self.navigationItem.title = self.challenge?.title
        self.navigationItem.hidesBackButton = false
        
        self.panGestureRecognizer.isEnabled = true
        let _ = naviController.popChallenge()
        
        for taker in (challenge?.takers)! {
            if (taker.user._id == naviController.user?._id && taker.accepted!) {
                imageView.layer.borderWidth = 5
                imageView.layer.borderColor = UIColor.green.cgColor
                isAccepted = true
                break
            }
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
            controller.user = naviController.user
            controller.challenge = naviController.getChallenge()
        }
        
        if (segue.identifier == "selectTakerSegue" && naviController.viewType == "SPONSORED") {
            guard let controller = segue.destination as? TakerNavigationController else {
                return
            }
            controller.allFriends = Array(naviController.user!.friends!.values)
            controller.takerDelegate = self
            
            if ((self.challenge?.takers?.count ?? 0) > 0) {
                controller.selectedFriends = [String: User]()
                for taker in self.challenge!.takers! {
                    controller.selectedFriends![taker.user._id!] = taker.user
                }
            }
            
            if (self.challenge!.isForCommunity) {
                controller.isCommunityChecked = true
            }
        }        
    }
    
    @IBAction func screenEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
        
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
            actionImageView.image = swipeRightImage
        } else {
            actionImageView.image = swipeLeftImage
        }
        
        self.actionImageView.alpha = abs(xFromCenter) / self.view.center.x
        actionImageView.backgroundColor = UIColor.white
        
        if (sender.state == UIGestureRecognizerState.ended) {
            if (container.center.x < 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x - 200, y: container.center.y + 75)
                })
                swipeLeft()
            }
            
            if (container.center.x > self.view.frame.width - 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x + 200, y: container.center.y + 75)
                })
                
                swipeRight()
            }
            self.reloadChallengeDetails()
            
            UIView.animate(withDuration: 0.3, animations: {
                container.center = self.view.center
                container.transform = CGAffineTransform.identity
                
                self.actionImageView.alpha = 0
            })
        }
    }
    
    public func swipeLeft() {
        do {
            let controller = self.navigationController as! ViewChallengeNavigationController
            try Server.rejectChallenge(user_id: controller.user!._id!, challenge_id: self.challenge!._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
            return
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
            return
        }
        
        delegate?.rejectChallenge(challenge: self.challenge!, challengeIndex: self.challengeIndex)
        challengeIndex += 1
    }
    
    public func swipeRight() {
        performSegue(withIdentifier: "cameraSegue", sender: self)
    }
    
    private func reloadChallengeDetails() {
        let controller = self.navigationController as! ViewChallengeNavigationController
        if (controller.isChallengeListEmpty()) {
            DispatchQueue.main.async{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
            }
            
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
    
    @IBAction func unwindToViewChallenge(segue: UIStoryboardSegue) {
        print("unwind")
    }
}

protocol ViewChallengeDelegate {
    func rejectChallenge(challenge: ChallengeDetails, challengeIndex: Int)
    func acceptChallenge(challenge: ChallengeDetails, challengeIndex: Int)
}

/*extension ViewChallengeParentController: SelectTakerDelegate {
    func selectionDone(selectTakerController: SelectTakerTableViewController) {
        
        let labelController = self.childViewControllers[0] as! ViewChallengeLabelController
        var new_takers: [Taker] = []
        
        for currUser in selectTakerController.selectedFriends!.values {
            if (!challenge!.takers!.contains(where: {$0.user._id == currUser._id})) {
                challenge?.addTaker(user: currUser)
                labelController.challenge?.addTaker(user: currUser)
                labelController.viewDidLoad()
                
                let newTaker = Taker.init(user: currUser)
                new_takers.append(newTaker)
            }
        }
        
        do {
            try Server.addTakers(challenge_id: (self.challenge?._id)!, new_takers: new_takers)
            
            
        } catch let cError as CustomError {
            print(cError.description)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}*/
