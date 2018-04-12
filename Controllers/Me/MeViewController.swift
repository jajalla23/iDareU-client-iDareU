//
//  MeViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/29/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import UIKit

class MeViewController: MeGenericViewController {
    var delegate: MeViewControllerDelegate?
    
    public var statusViewController: StatusViewController!
    private var isMyStatusExpanded: Bool = false
    @IBOutlet weak var myStatusHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var myStatusView: UIView!
    @IBOutlet weak var statusHeaderBtn: UIButton!
    
    public var pendingViewController: PendingChallengesViewController!
    private var isPendingChallengesExpanded: Bool = true
    private var pendingChallengeRowHeight: Int = 80
    @IBOutlet weak var pendingChallengesHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var pendingChallengesView: UIView!
    @IBOutlet weak var pendingHeaderBtn: UIButton!
    @IBOutlet weak var pendingCountLbl: UILabel!
    

    public var createdChallengeViewController: MyCreatedChallengesViewController!
    private var isCreatedChallengesExpanded: Bool = false
    private var createdChallengeRowHeight: Int = 80
    @IBOutlet weak var createdChallengesHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var createdChallengesView: UIView!
    @IBOutlet weak var sponsoredHeaderBtn: UIButton!
    
    public var completedChallengeViewController: CompletedChallengesViewController!
    private var isCompletedChallengesExpanded: Bool = false
    private var completedChallengeRowHeight: Int = 80
    @IBOutlet weak var completedChallengesHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var completedChallengesView: UIView!
    @IBOutlet weak var completedHeaderBtn: UIButton!

    private var statusViewLayer: CALayer?
    private var isAlreadyShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.pendingViewController = self.childViewControllers[0] as! PendingChallengesViewController
        self.statusViewController = self.childViewControllers[1] as! StatusViewController
        self.createdChallengeViewController = self.childViewControllers[2] as! MyCreatedChallengesViewController
        self.completedChallengeViewController = self.childViewControllers[3] as! CompletedChallengesViewController
        
        //created challenges minimized
        self.createdChallengesHeightConstr.constant = 0
        self.createdChallengesView.isHidden = true
        
        //completed challenges minimized
        self.completedChallengesHeightConstr.constant = 80
        self.completedChallengesView.isHidden = true
        
        if (user?.challenges?.pending?.count == 0) {
                pendingCountLbl.isHidden = true
        }
        
        pendingCountLbl.text = user?.challenges?.pending?.count.description
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshAllViews), name: NSNotification.Name(rawValue: "refreshAllViewsOnMe"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isAlreadyShown {
            return
        }
        
        if ((user?.challenges?.pending?.count ?? 0) > 0) {
            var height: CGFloat = CGFloat(self.pendingChallengeRowHeight * (self.user?.challenges?.pending?.count ?? 0))
            if (height > PendingChallengesViewController.scrollViewMaxHeight) {
                height = PendingChallengesViewController.scrollViewMaxHeight
            }
            
            self.pendingChallengesHeightConstr.constant = height
            self.pendingChallengesView.isHidden = false
            self.pendingHeaderBtn.transform = self.pendingHeaderBtn.transform.rotated(by: CGFloat.pi)
            
            self.myStatusHeightConstr.constant = 0
            statusViewLayer?.removeFromSuperlayer()
            self.myStatusView.isHidden = true
        } else {
            //pending challenges minimized
            self.isPendingChallengesExpanded = false
            self.pendingChallengesHeightConstr.constant = 0
            self.pendingChallengesView.isHidden = true
            
            self.isMyStatusExpanded = true
            self.myStatusHeightConstr.constant = StatusViewController.statusViewHeight
            self.myStatusView.isHidden = false
            self.statusHeaderBtn.transform = self.statusHeaderBtn.transform.rotated(by: CGFloat.pi)
        }
        
        statusViewLayer = myStatusView.layer.sublayers?[0]
        isAlreadyShown = true
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? MeGenericViewController
        controller?.user = self.user
    }
    
    @IBAction func myStatusBtnToggled(_ sender: Any) {
        toggleStatus()
    }
    
    @IBAction func myStatusHeaderTapped(_ sender: UITapGestureRecognizer) {
        toggleStatus()
    }
    
    @IBAction func pendingChallBtnToggled(_ sender: Any) {
        togglePending()
    }
    
    @IBAction func pendingHeaderTapped(_ sender: UITapGestureRecognizer) {
        togglePending()
    }
    
    @IBAction func createdChallBtnToggled(_ sender: Any) {
        toggleSponsor()
    }
    
    @IBAction func sponsorHeaderTapped(_ sender: UITapGestureRecognizer) {
        toggleSponsor()
    }
    
    @IBAction func completedChallBtnToggled(_ sender: Any) {
        toggleCompleted()
    }
    
    @IBAction func completedHeaderTapped(_ sender: UITapGestureRecognizer) {
        toggleCompleted()
    }
    
    private func toggleStatus() {
        if self.isCreatedChallengesExpanded {
            self.toggleCreatedChallengesView()
        }
        
        if self.isPendingChallengesExpanded {
            self.togglePendingChallengesView()
        }
        
        if self.isCreatedChallengesExpanded {
            self.toggleCreatedChallengesView()
        }
        
        if self.isCompletedChallengesExpanded {
            self.toggleCompleted()
        }
        
        self.toggleStatusView()

        delegate?.adjustView(meViewController: self)
    }
    
    private func togglePending() {
        if ((user?.challenges?.pending?.count ?? 0) == 0) {
            return
        }
        
        if self.isMyStatusExpanded {
            self.toggleStatusView()
        }
        
        if self.isCreatedChallengesExpanded {
            self.toggleCreatedChallengesView()
        }
        
        if self.isCompletedChallengesExpanded {
            self.toggleCompleted()
        }
        
        self.togglePendingChallengesView()
        
        delegate?.adjustView(meViewController: self)
    }
    
    private func toggleSponsor() {
        if ((user?.challenges?.sponsored?.count ?? 0) == 0) {
            return
        }
        
        if self.isMyStatusExpanded {
            self.toggleStatusView()
        }
        
        if self.isPendingChallengesExpanded {
            self.togglePendingChallengesView()
        }
        
        if self.isCompletedChallengesExpanded {
            self.toggleCompleted()
        }
        
        self.toggleCreatedChallengesView()
        
        delegate?.adjustView(meViewController: self)
    }
    
    private func toggleCompleted() {
        if ((user?.challenges?.completed?.count ?? 0) == 0) {
            return
        }
        
        if self.isPendingChallengesExpanded {
            self.togglePendingChallengesView()
        }
        
        if self.isMyStatusExpanded {
            self.toggleStatusView()
        }
        
        if self.isCreatedChallengesExpanded {
            self.toggleCreatedChallengesView()
        }
        
        self.toggleCompletedChallengesView()

        delegate?.adjustView(meViewController: self)
    }
    
    private func toggleStatusView() {
        if (isMyStatusExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.myStatusHeightConstr.constant = 0
                self.statusHeaderBtn.transform = self.statusHeaderBtn.transform.rotated(by: CGFloat.pi)

                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.myStatusView.isHidden = !self.myStatusView.isHidden
                self.statusViewLayer?.removeFromSuperlayer()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.myStatusHeightConstr.constant = StatusViewController.statusViewHeight
                self.statusHeaderBtn.transform = self.statusHeaderBtn.transform.rotated(by: CGFloat.pi)
                self.myStatusView.layer.addSublayer(self.statusViewLayer!)
                self.myStatusView.isHidden = !self.myStatusView.isHidden
                self.view.layoutIfNeeded()
            })
            
            self.statusViewController.expandView()
        }
        
        isMyStatusExpanded = !isMyStatusExpanded
    }
    
    private func togglePendingChallengesView() {
        if (isPendingChallengesExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.pendingChallengesView.isHidden = !self.pendingChallengesView.isHidden
                self.pendingViewController.collapseView()
                self.pendingChallengesHeightConstr.constant = 0
                self.pendingHeaderBtn.transform = self.pendingHeaderBtn.transform.rotated(by: -CGFloat.pi)
                
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                var height: CGFloat = CGFloat(self.pendingChallengeRowHeight * (self.user?.challenges?.pending?.count ?? 0))
                
                if (height > PendingChallengesViewController.scrollViewMaxHeight) {
                    height = PendingChallengesViewController.scrollViewMaxHeight
                }

                self.pendingChallengesHeightConstr.constant = height
                self.pendingChallengesView.isHidden = !self.pendingChallengesView.isHidden
                self.pendingHeaderBtn.transform = self.pendingHeaderBtn.transform.rotated(by: CGFloat.pi)

                self.pendingViewController.expandView()
                self.view.layoutIfNeeded()
            })
        }
        
        isPendingChallengesExpanded = !isPendingChallengesExpanded
    }
    
    private func toggleCreatedChallengesView() {
        if (isCreatedChallengesExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.createdChallengesView.isHidden = !self.createdChallengesView.isHidden
                self.createdChallengeViewController.collapseView()
                self.sponsoredHeaderBtn.transform = self.sponsoredHeaderBtn.transform.rotated(by: CGFloat.pi)

            }, completion: { (finished: Bool) in
                self.createdChallengesHeightConstr.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                var height: CGFloat = CGFloat(self.createdChallengeRowHeight * (self.user?.challenges?.sponsored?.count ?? 0))
                
                if (height > MyCreatedChallengesViewController.scrollViewMaxHeight) {
                    height = MyCreatedChallengesViewController.scrollViewMaxHeight
                }
                
                self.createdChallengeViewController.expandView()
                self.createdChallengesHeightConstr.constant = height
                self.sponsoredHeaderBtn.transform = self.sponsoredHeaderBtn.transform.rotated(by: CGFloat.pi)

                self.createdChallengesView.isHidden = !self.createdChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
        isCreatedChallengesExpanded = !isCreatedChallengesExpanded
    }
    
    private func toggleCompletedChallengesView() {
        if (isCompletedChallengesExpanded) {
            UIView.animate(withDuration: 1.0, animations: {
                self.completedChallengesView.isHidden = !self.completedChallengesView.isHidden
                self.completedChallengeViewController.collapseView()
                self.completedHeaderBtn.transform = self.completedHeaderBtn.transform.rotated(by: CGFloat.pi)
                
            }, completion: { (finished: Bool) in
                self.completedChallengesHeightConstr.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                var height: CGFloat = CGFloat(self.completedChallengeRowHeight * (self.user?.challenges?.completed?.count ?? 0))
                if (height > CompletedChallengesViewController.scrollViewMaxHeight) {
                    height = CompletedChallengesViewController.scrollViewMaxHeight
                }
                
                self.completedChallengeViewController.expandView()
                self.completedChallengesHeightConstr.constant = height
                self.completedHeaderBtn.transform = self.completedHeaderBtn.transform.rotated(by: CGFloat.pi)
                
                self.completedChallengesView.isHidden = !self.completedChallengesView.isHidden
                self.view.layoutIfNeeded()
            })
        }
        
        isCompletedChallengesExpanded = !isCompletedChallengesExpanded
    }
    
    @objc func refreshAllViews(){
        self.pendingViewController.reloadTableData()
        self.createdChallengeViewController.reloadTableData()
        
        if (isMyStatusExpanded) {
            self.myStatusHeightConstr.constant = StatusViewController.statusViewHeight
            self.statusViewController.needsRefresh = true
        }
        
        if (isPendingChallengesExpanded) {
            var height: CGFloat = CGFloat(self.pendingChallengeRowHeight * (self.user?.challenges?.pending?.count ?? 0))
            
            if (height > PendingChallengesViewController.scrollViewMaxHeight) {
                height = PendingChallengesViewController.scrollViewMaxHeight
            }
            
            self.pendingChallengesHeightConstr.constant = height
            self.view.layoutIfNeeded()
        }
        
        if (isCreatedChallengesExpanded) {
            var height: CGFloat = CGFloat(self.createdChallengeRowHeight * (self.user?.challenges?.sponsored?.count ?? 0))
            
            if (height > MyCreatedChallengesViewController.scrollViewMaxHeight) {
                height = MyCreatedChallengesViewController.scrollViewMaxHeight
            }
            
            self.createdChallengesHeightConstr.constant = height
            self.view.layoutIfNeeded()
        }

        self.view.layoutIfNeeded()
    }
    
    func refreshAllViews_v2(user: User){
        self.user = user
        self.pendingViewController.user = user
        self.pendingViewController.reloadTableData()
        
        self.statusViewController.user = user
        
        self.createdChallengeViewController.user = user
        self.createdChallengeViewController.reloadTableData()
        
        if (isMyStatusExpanded) {
            self.myStatusHeightConstr.constant = StatusViewController.statusViewHeight
            self.statusViewController.needsRefresh = true
            self.statusViewController.refresh()
        }
        
        if (isPendingChallengesExpanded) {
            var height: CGFloat = CGFloat(self.pendingChallengeRowHeight * (self.user?.challenges?.pending?.count ?? 0))
            
            if (height > PendingChallengesViewController.scrollViewMaxHeight) {
                height = PendingChallengesViewController.scrollViewMaxHeight
            }
            
            self.pendingChallengesHeightConstr.constant = height
            self.view.layoutIfNeeded()
        }
        
        if (isCreatedChallengesExpanded) {
            var height: CGFloat = CGFloat(self.createdChallengeRowHeight * (self.user?.challenges?.sponsored?.count ?? 0))
            
            if (height > MyCreatedChallengesViewController.scrollViewMaxHeight) {
                height = MyCreatedChallengesViewController.scrollViewMaxHeight
            }
            
            self.createdChallengesHeightConstr.constant = height
            self.view.layoutIfNeeded()
        }
        
        self.view.layoutIfNeeded()
    }
}

protocol MeViewControllerDelegate {
    func adjustView(meViewController: MeViewController)
}
