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
        
        animate(jansAvail: self.getJansAvailable(), pctComplete: self.calculatePctCompleted())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (self.needsRefresh) {
            self.animate(jansAvail: self.getJansAvailable(), pctComplete: self.calculatePctCompleted())
            self.needsRefresh = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func statusViewTapped(_ sender: UITapGestureRecognizer) {
        self.animate(jansAvail: self.getJansAvailable(), pctComplete: self.calculatePctCompleted())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func calculatePctCompleted() -> Double {
        let challengesPending = Double(self.user?.challenges?.pending?.count ?? 0)
        let challengesCompleted = Double(self.user?.challenges?.completed?.count ?? 0)
        
        var pctCompleted = 0.0
        if ((challengesPending + challengesCompleted) > 0) {
            pctCompleted = (challengesCompleted/(challengesPending + challengesCompleted))
        }
        
        return pctCompleted
    }
    
    private func getJansAvailable() -> Double {
        let temp = (self.user?.jans?.available ?? 100) as NSNumber
        return Double(truncating: temp)
    }
    
    @objc public func animate(jansAvail: Double, pctComplete: Double) {
        jansValueLbl.format = "J %.02f"
        jansValueLbl.countFrom(0, to: CGFloat(jansAvail), withDuration: 1.7)
        
        pctComLbl.format = "%d%%"
        pctComLbl.countFrom(0, to: CGFloat(pctComplete * 100), withDuration: 1.3)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = pctComplete - 0.1
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func expandView() {
        animate(jansAvail: self.getJansAvailable(), pctComplete: self.calculatePctCompleted())
    }
    
    func refresh() {
        animate(jansAvail: self.getJansAvailable(), pctComplete: self.calculatePctCompleted())
    }

}
