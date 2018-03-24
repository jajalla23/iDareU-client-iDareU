//
//  PreviewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 3/22/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
    public var user: User?
    public var challenge: ChallengeDetails?
    public var taker: Taker?
    public var image: UIImage?
    
    private var isSetupShown: Bool = false
    private var setupViewOrigHeight: CGFloat?
    private var setupViewOriginY: CGFloat?
    
    @IBOutlet weak var previewImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = (challenge?.title ?? "") + " Response"
        self.previewImg.image = self.image
        
        #if SIMULATOR
            self.previewImg.image = #imageLiteral(resourceName: "Play")
        #endif
        
        self.previewImg.contentMode = .scaleAspectFit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func closeView(_ sender: Any) {
        performSegue(withIdentifier: "unwindToCamera", sender: sender)
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        let uuid = UUID.init()
        
        let dispatchGroup = DispatchGroup()
        self.taker?.completed = true
        self.taker?.addMedia(fileName: uuid.uuidString, type: "image/jpg", imagePrevURL: nil)
        
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
            try Server.completeChallenge(challenge_id: challenge!._id!, taker: taker!)
        } catch let c_error as CustomError {
            print(c_error)
        } catch let error {
            print(error)
        }
        
        let timeoutResult = dispatchGroup.wait(timeout: DispatchTime.now() + 10)
        if (timeoutResult == .success) {
            DispatchQueue.main.async {
                //add challenge to completed
                self.user?.challenges?.addCompletedChallenge(challengeDetail: self.challenge!)
                
                //remove challenge from pending
                let temp = (self.user?.challenges?.pending!.filter {
                    $0._id != self.challenge?._id
                    })!
                self.user?.challenges?.pending? = temp
            }
        } else if (timeoutResult == .timedOut) {
            print("Server Error")
            return
        }
        
        DispatchQueue.main.async{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
        }
        
        performSegue(withIdentifier: "previewUnwindSegue", sender: sender)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

