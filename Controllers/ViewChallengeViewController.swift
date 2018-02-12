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

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let controller = self.navigationController as! ViewChallengeNavigationController
        self.challenge = controller.challenge

        self.navigationItem.title = self.challenge?.title
        self.navigationItem.hidesBackButton = false

        do {
            let imageData = try Server.fetchMedia(mediaName: self.challenge!.media!.fileName, mediaType: self.challenge!.media!.type)
            
            if (imageData?.isGzipped)! {
                let unzippedData = try imageData?.gunzipped()
                self.imageView.image = UIImage(data: unzippedData!, scale: 1.0)
            } else {
                self.imageView.image = UIImage(data: imageData!, scale: 1.0)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
