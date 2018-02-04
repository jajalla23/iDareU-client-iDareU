//
//  StatusViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/7/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class StatusViewController: MeGenericViewController {
    public var needsRefresh: Bool = false
    
    @IBOutlet weak var jansView: UIView!
    @IBOutlet weak var jansValueLbl: EFCountingLabel!
    
    @IBOutlet weak var pctComLbl: EFCountingLabel!
    @IBOutlet weak var completionStatusView: UIView!

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        let center = completionStatusView.center
        let trackLayer = CAShapeLayer()
        
        let circularPath =
            UIBezierPath(arcCenter: center, radius: 100,
                                        startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(trackLayer)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        let temp = (self.user?.jans?.available ?? 100) as NSNumber
        let jansAvail: Double = Double(truncating: temp)

        let challengesPending = Double(self.user?.challenges?.pending?.count ?? 0)
        let challengesCompleted = Double(self.user?.challenges?.completed?.count ?? 0)
        
        let pctCompleted = (challengesCompleted/(challengesPending + challengesCompleted))
        
        animate(jansAvail: jansAvail, pctComplete: pctCompleted)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.needsRefresh) {
            let temp = (self.user?.jans?.available ?? 100) as NSNumber
            let jansAvail: Double = Double(truncating: temp)
            
            let challengesPending = Double(self.user?.challenges?.pending?.count ?? 0)
            let challengesCompleted = Double(self.user?.challenges?.completed?.count ?? 0)
            
            let pctCompleted = (challengesCompleted/(challengesPending + challengesCompleted))
            
            self.animate(jansAvail: jansAvail, pctComplete: pctCompleted)
            self.needsRefresh = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func statusViewTapped(_ sender: UITapGestureRecognizer) {
        let temp = (user?.jans?.available ?? 100) as NSNumber
        let jansAvail: Double = Double(truncating: temp)
        
        let challengesPending = Double(user?.challenges?.pending?.count ?? 1)
        let challengesCompleted = Double(user?.challenges?.completed?.count ?? 0)
        let pctCompleted = (challengesCompleted/(challengesPending + challengesCompleted))
        
        animate(jansAvail: jansAvail, pctComplete: pctCompleted)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc public func animate(jansAvail: Double, pctComplete: Double) {
        jansValueLbl.format = "J %.02f"
        jansValueLbl.countFrom(0, to: CGFloat(jansAvail), withDuration: 2.0)
        
        pctComLbl.format = "%d%%"
        pctComLbl.countFrom(0, to: CGFloat(pctComplete * 100), withDuration: 1.5)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = pctComplete - 0.1
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }

}
