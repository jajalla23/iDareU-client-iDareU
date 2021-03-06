//
//  SetupChallengeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 2/2/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class SetupChallengeViewController: UIViewController, UITextFieldDelegate {
    var delegate: SetupChallengeDelegate?

    public var user: User?
    public var image: UIImage?
    private var orig_setUpframeYaxis: CGFloat?
    
    //challengeinfo
    public var challenge: ChallengeDetails?
    public var sponsors: [User]?
    
    @IBOutlet weak var dareLbl: UILabel!
    @IBOutlet weak var sponsorBtn: UIButton!
    @IBOutlet weak var takerBtn: UIButton!
    @IBOutlet weak var challengeTitleTxtField: UITextField!
    @IBOutlet weak var challengeRewardBtn: UIButton!
    @IBOutlet weak var expirationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = UIColor.clear
        //view.isOpaque = false
        self.orig_setUpframeYaxis = self.view.frame.origin.y

        self.challengeTitleTxtField.delegate = self;

        if (challenge == nil) {
            challenge = ChallengeDetails.init(sponsorId: self.user?._id ?? "00000", sponsor_displayName: "no name", title: "Untitled Challenge", description: "", reward: 0)
            challenge?.addSponsor(user: self.user!, reward: 1)
            self.sponsors = []
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let availHalf = (user?.jans?.available ?? 0) / 2
        challengeRewardBtn.setTitle("J \(availHalf)", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hideSetupBtnTapped(_ sender: Any) {
        self.delegate?.closeSetupView(setupChallengeController: self)
    }
    
    @IBAction func sponsorBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "selectSponsorSegue" , sender : self)
    }
    
    @IBAction func takerBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "selectTakerSegue", sender: sender)
    }
    
    @IBAction func challengeEditEnded(_ sender: Any) {
        if (self.challengeTitleTxtField!.text!.count == 0) {
            self.challengeTitleTxtField.textColor = UIColor.red
            self.challengeTitleTxtField.text = "CHALLENGE"
            self.challenge?.title = "Untitled Challenge"
            
            return
        }
        
        self.challenge?.title = self.challengeTitleTxtField!.text!
        if (self.challengeTitleTxtField!.text!.count > 10) {
            var temp = String(self.challengeTitleTxtField!.text!.prefix(8))
            temp += "..."
            self.challengeTitleTxtField!.text = temp
        }
    }
    
    @IBAction func rewardBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "setupRewardSegue", sender: sender)
    }
    
    @IBAction func expirationBtnTapped(_ sender: Any) {
    }   
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        self.challenge?.title = self.challengeTitleTxtField.text!
        let uuid = UUID.init()
        
        if (self.sponsors!.count == 0) {
            var response = [self.challenge!]
            //update server to add to sponsored challenge
            
            let dispatchGroup = DispatchGroup()
            self.challenge?.addMedia(fileName: uuid.uuidString, type: "image/jpg", imagePrevURL: nil)//TODO: mediatype
            
            do {
                dispatchGroup.enter()
                try Server.uploadMedia(media: self.image!.compressJPEGImage(), type: (self.challenge?.media?.type ?? "image/jpg"), uuid: uuid)
                dispatchGroup.leave()
            } catch let c_error as CustomError {
                print(c_error)
                dispatchGroup.leave()
            } catch let error {
                print(error)
                dispatchGroup.leave()
            }
            
            do {
                response = try Server.createChallenge(challenges: response)
            } catch let c_error as CustomError {
                print(c_error)
            } catch let error {
                print(error)
            }
            
            let timeoutResult = dispatchGroup.wait(timeout: DispatchTime.now() + 10)
            if (timeoutResult == .success) {
                DispatchQueue.main.async {
                    self.user?.challenges?.addSponsoredChallenge(challengeDetail: response[0])
                    let reward = response[0].reward
                    
                    self.user?.jans?.available -= reward
                    self.user?.jans?.committed += reward
                }
            }
            
            
        } else {
            let split_reward = self.challenge!.reward/self.sponsors!.count
            let main_sponsor = self.sponsors!.popLast()
            
            self.challenge?.addSponsor(user: main_sponsor!, reward: split_reward)
            
            for sponsor in self.sponsors! {
                self.challenge?.addCosponsor(user: sponsor, reward: split_reward)
            }
            
            self.user?.addPendingChallenges(challengeDetail: self.challenge!)

            //Update server to add pending challenge
        }
        
        //update screens
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
        
        performSegue(withIdentifier: "setupToCreateUnwind", sender: sender)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier!) {
        case "selectTakerSegue":
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
        case "selectSponsorSegue":
            guard let controller = segue.destination as? SelectSponsorTableViewController else {
                return
            }
            controller.user = self.user
            controller.challengeToBeSetup = self.challenge
            controller.allFriends = Array(self.user!.friends!.values)
            
            if ((self.sponsors?.count ?? 0) > 0) {
                controller.selectedFriend = self.sponsors?[0]
            }
        case "setupRewardSegue":
            guard let controller = segue.destination as? UpdateChallengeRewardController else {
                return
            }
            controller.source = "SETUP"
            controller.user = self.user
            controller.challenge_reward = (self.user?.jans?.available ?? 0)/2
            controller.challenge_title = self.challengeTitleTxtField.text
             
            controller.viewTitle = "Set Reward"
            controller.viewAction = ""
            
        case "setupToCreateUnwind":
            guard let controller = segue.destination as? GenericUIViewController else {
                return
            }
            
            let tabController = controller.tabBarController as! RouterTabBarController
            tabController.user = self.user
            
            //NSStringFromClass(self.classForCoder)
            
        case "sendChallengeSegue":
            guard let controller = segue.destination as? RouterTabBarController else {
                return
            }
            
            controller.user = self.user
            
            self.navigationController?.popViewController(animated: false)
            self.dismiss(animated: false, completion: nil)
            
        default:
            return
        }
    }
    
    @IBAction func unwindToSetupChallenge(segue: UIStoryboardSegue) {
        //print("reward: " + (self.challenge?.reward.description)!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = self.orig_setUpframeYaxis!
    }
    
}

extension SetupChallengeViewController: SelectTakerDelegate {
    func selectionDone(selectTakerController: SelectTakerTableViewController) {
        for friend in selectTakerController.selectedFriends!.values {
            self.challenge?.addTaker(user: friend)
        }
        
        self.challenge?.isForCommunity = false
        if (selectTakerController.isCommunityChecked) {
            self.takerBtn.setTitle("anyone", for: UIControlState.normal)
            self.challenge?.isForCommunity = true
        } else if (selectTakerController.selectedFriends!.count == 1) {
            let friend: User = selectTakerController.selectedFriends!.first!.value
            self.takerBtn.setTitle(friend.display_name, for: UIControlState.normal)
        } else {
            self.takerBtn.setTitle("people", for: UIControlState.normal)
            
        }
    }
}

protocol SetupChallengeDelegate {
    func closeSetupView(setupChallengeController: SetupChallengeViewController)
    
}
