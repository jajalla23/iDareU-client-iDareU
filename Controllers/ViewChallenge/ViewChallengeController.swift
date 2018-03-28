//
//  ViewChallengeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/10/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewChallengeViewController: UIViewController, UIGestureRecognizerDelegate {

    private let error_location = "/Controllers/ViewChallengeViewController.swift"
    private var divisor: CGFloat?
    private var challengeIndex: Int = 0
    private var isAccepted: Bool = false
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var challengeInfoView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var user: User?
    var viewType: String?
    var challengeQueue: Queue<ChallengeDetails>?
    var delegate: ViewChallengeDelegate?
    var challenge: ChallengeDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        challengeInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.challenge = self.popChallenge()
        self.divisor = (view.frame.width / 2) / 0.61

        if (self.viewType == "PENDING") {
            self.panGestureRecognizer.isEnabled = true
            
            for taker in (challenge?.takers)! {
                if (taker.user._id == self.user?._id && taker.accepted!) {
                    imageView.layer.borderWidth = 5
                    imageView.layer.borderColor = UIColor.green.cgColor
                    isAccepted = true
                    break
                }
            }
        } else if (viewType == "SPONSORED") {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "second"), style: .done, target: self, action: #selector(rightBarBtnTapped))
        }
        
        do {
            var media_name: String?
            var media_type: String?
            if (self.viewType == "COMPLETED") {
                if let taker = challenge?.takers?.first(where: {$0.user._id == self.user?._id}) {
                    media_name = taker.media?.fileName
                    media_type = taker.media?.type
                } else {
                    let cError: CustomError = CustomError.init(code: "001", description: "Missing Media Name", severity: .HIGH, location: error_location)
                    throw cError
                }
            } else {
                media_name = challenge!.media!.fileName
                media_type = challenge!.media!.type
            }

            let imageData = try Server.fetchMedia(mediaName: media_name!, mediaType: media_type!)
            self.imageView.image = UIImage(data: imageData!, scale: 1.0)
            self.imageView.contentMode = .scaleAspectFit
            
        } catch let cError as CustomError {
            print(cError.description)
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
            controller.user = self.user
            controller.challenge = self.challengeQueue?.peek()
        }
        
        if (segue.identifier == "selectTakerSegue" && self.viewType == "SPONSORED") {
            guard let controller = segue.destination as? TakerNavigationController else {
                return
            }
            controller.allFriends = Array(self.user!.friends!.values)
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
        
        if (segue.identifier == "cameraSegue") {
            let controller = segue.destination as? CameraController
            controller?.challenge = self.challenge
            controller?.user = self.user
            
            for taker in (challenge?.takers)! {
                if (taker.user._id == controller?.user?._id) {
                    controller?.taker = taker
                    break
                }
            }
        }
        
    }
    
    @objc func rightBarBtnTapped() {
        self.performSegue(withIdentifier: "selectTakerSegue", sender: self)
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
            if (isAccepted) {
                actionImageView.image = #imageLiteral(resourceName: "complete")
            } else {
                actionImageView.image = #imageLiteral(resourceName: "accept")
            }
        } else {
            actionImageView.image = #imageLiteral(resourceName: "decline")
        }
        
        self.actionImageView.alpha = abs(xFromCenter) / self.view.center.x
        actionImageView.backgroundColor = UIColor.white

        if (sender.state == UIGestureRecognizerState.ended) {
            if (container.center.x < 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x - 200, y: container.center.y + 75)
                })
                declineChallenge()
                self.reloadChallengeDetails()
            }
            
            if (container.center.x > self.view.frame.width - 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x + 200, y: container.center.y + 75)
                })
                
                if (!isAccepted) {
                    acceptChallenge()
                    self.reloadChallengeDetails()
                } else {
                    completeChallenge()
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                container.center = self.view.center
                container.transform = CGAffineTransform.identity

                self.actionImageView.alpha = 0
            })
        }
        
    }
    
    private func declineChallenge() {
        do {
            try Server.declineChallenge(user_id: self.user!._id!, challenge_id: self.challenge!._id!)
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
    
    private func acceptChallenge() {
        do {
            //let controller = self.navigationController as! ViewChallengeNavigationController
            try Server.acceptChallenge(user_id: self.user!._id!, challenge_id: self.challenge!._id!)
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
        }
        
        delegate?.acceptChallenge(challenge: self.challenge!, challengeIndex: self.challengeIndex)
        challengeIndex += 1
    }
    
    private func completeChallenge() {
        performSegue(withIdentifier: "cameraSegue", sender: self)
    }
    
    private func reloadChallengeDetails() {
        //let controller = self.navigationController as! ViewChallengeNavigationController
        if (self.isChallengeListEmpty()) {
            DispatchQueue.main.async{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
            }
            
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.challenge = self.popChallenge()
        self.navigationItem.title = self.challenge?.title
        
        do {
            let imageData = try Server.fetchMedia(mediaName: self.challenge!.media!.fileName, mediaType: self.challenge!.media!.type)
            
            self.imageView.image = UIImage(data: imageData!, scale: 1.0)
            self.imageView.contentMode = .scaleAspectFit
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
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
    
    @IBAction func screenEdgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func popChallenge() -> ChallengeDetails {
        return (self.challengeQueue?.pop())!
    }
    
    private func getChallenge() -> ChallengeDetails {
        return (self.challengeQueue?.peek())!
    }
    
    private func isChallengeListEmpty() -> Bool {
        return self.challengeQueue!.isEmpty
    }
    
}

protocol ViewChallengeDelegate {
    func rejectChallenge(challenge: ChallengeDetails, challengeIndex: Int)
    func acceptChallenge(challenge: ChallengeDetails, challengeIndex: Int)
}

extension ViewChallengeViewController: SelectTakerDelegate {
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
}

