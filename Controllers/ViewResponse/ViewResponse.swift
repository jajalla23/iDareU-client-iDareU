//
//  ViewResponse.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/25/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class ViewResponseController: UIViewController {
    
    private let error_location = "/Controllers/Response/ViewResponse.swift"
    var user: User?
    var challenge: ChallengeDetails?
    var taker: Taker?
    
    private var divisor: CGFloat?
    private var challengeIndex: Int = 0
    private var isAccepted: Bool = false
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var challengeInfoView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.panGestureRecognizer.isEnabled = true
        challengeInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.divisor = (view.frame.width / 2) / 0.61
        self.navigationItem.title = self.challenge?.title
        self.navigationItem.hidesBackButton = false
        
        do {
            if let media_name = taker?.media?.fileName {
                let imageData = try Server.fetchMedia(mediaName: media_name, mediaType: taker!.media!.type)
                self.imageView.image = UIImage(data: imageData!, scale: 1.0)
                self.imageView.contentMode = .scaleAspectFit
            }
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
        if (segue.identifier == "responseLabelSegue") {
            let controller = segue.destination as! ResponseLabelController
            controller.user = user
            controller.challenge = challenge
        }
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        challengeInfoView.isHidden = !challengeInfoView.isHidden
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
                swipeLeft()
            }
            
            if (container.center.x > self.view.frame.width - 65) {
                UIView.animate(withDuration: 0.3, animations: {
                    container.center = CGPoint(x: container.center.x + 200, y: container.center.y + 75)
                })
                swipeRight()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                container.center = self.view.center
                container.transform = CGAffineTransform.identity
                
                self.actionImageView.alpha = 0
            })
        }
        
    }
    
    private func swipeLeft() {
        do {
            //reject response
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
            return
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
            return
        }
        
        challengeIndex += 1
    }
    
    private func swipeRight() {
        do {
            //accept response
        } catch let cError as CustomError {
            //TODO: handler error
            print(cError.description)
        } catch let error {
            //TODO: error
            print(error.localizedDescription)
        }
        
        challengeIndex += 1
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
}
