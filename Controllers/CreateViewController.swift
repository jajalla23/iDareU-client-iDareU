//
//  CaptureViewController.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/30/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CreateViewController: GenericUIViewController {
    
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var capturedImage: UIImage?
    
    private var isCaptureVideo: Bool = false
    private var captureDevice: AVCaptureDevice?
    private var capturePosition: AVCaptureDevice.Position?
    private var flashMode: AVCaptureDevice.FlashMode?
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet weak var cameraSettingsBtn: UIButton!
    @IBOutlet var cameraTools: [UIButton]! {
        didSet {
            cameraTools.forEach {
                $0.isHidden = true
                $0.backgroundColor = UIColor(white: 1, alpha: 0.5)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.isNavigationBarHidden = true
        let tabController = self.tabBarController as! RouterTabBarController
        self.user = tabController.user
        
        cameraSettingsBtn.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        #if !SIMULATOR
            self.cameraTools.forEach {
                $0.isEnabled = true
            }
            self.setupCaptureDevice()
            self.setupCamera()
        #endif

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCaptureDevice() {
        self.flashMode = AVCaptureDevice.FlashMode.auto
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            self.captureDevice = dualCameraDevice
            self.capturePosition = AVCaptureDevice.Position.back
        }
            
        else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            self.captureDevice = backCameraDevice
            self.capturePosition = AVCaptureDevice.Position.back
        }
            
        else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            self.captureDevice = frontCameraDevice
            self.capturePosition = AVCaptureDevice.Position.front
        }
    }
    
    private func setupCamera() {
        var captureSession: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        
        var input: AVCaptureDeviceInput? = nil
        do {
            input = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            print(error)
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        
        self.previewView.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    @IBAction func onCaptureBtnTapped(_ sender: Any) {
        #if SIMULATOR
            self.performSegue(withIdentifier: "previewSegue", sender: self)
        #endif
        
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = self.flashMode!

        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = view.bounds.size
        if let touchPoint = touches.first {
            let x = touchPoint.location(in: view).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: view).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
            if let device = captureDevice {
                do {
                    try device.lockForConfiguration()
                    
                    device.focusPointOfInterest = focusPoint
                    //device.focusMode = .continuousAutoFocus
                    device.focusMode = .autoFocus
                    //device.focusMode = .locked
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                }
                catch {
                    // just ignore
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "previewSegue") {
            guard let controller = segue.destination as? PreviewViewController else {
                return
            }
            controller.image = self.capturedImage
            controller.user = self.user
        }
    }
    
    @IBAction func onSettingsTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {
            self.cameraTools.forEach {
                $0.isHidden = !$0.isHidden
            }
        }
    }
    
    @IBAction func cameraRotateBtnTapped(_ sender: Any) {
        if (self.capturePosition == AVCaptureDevice.Position.front) {
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
                self.captureDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                self.captureDevice = backCameraDevice
            }
            
            self.capturePosition = AVCaptureDevice.Position.back
            
        } else {
            if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                self.captureDevice = frontCameraDevice
                self.capturePosition = AVCaptureDevice.Position.front
            }
        }
        setupCamera()
    }
    
    @IBAction func cameraFlashBtnTapped(_ sender: Any) {
        do {
            try captureDevice?.lockForConfiguration()
        } catch let error {
            print(error.localizedDescription)
            return
        }
        if (self.flashMode == AVCaptureDevice.FlashMode.off) {
            self.flashMode = AVCaptureDevice.FlashMode.auto
            cameraTools[1].setImage(UIImage(named: "camera_flash_auto"), for: .normal)
        } else if (self.flashMode == AVCaptureDevice.FlashMode.auto) {
            self.flashMode = AVCaptureDevice.FlashMode.on
            cameraTools[1].setImage(UIImage(named: "camera_flash_on"), for: .normal)
        } else {
            //captureDevice?.torchMode = AVCaptureDevice.TorchMode.off
            self.flashMode = AVCaptureDevice.FlashMode.off
            cameraTools[1].setImage(UIImage(named: "camera_flash_off"), for: .normal)
        }
        
        captureDevice?.unlockForConfiguration()
    }
    
    @IBAction func unwindToCreate(segue: UIStoryboardSegue) {}
    
    func prepare(completionHandler: @escaping (Error?) -> Void) { }
    
    @IBAction func edgePanned(_ sender: UIScreenEdgePanGestureRecognizer) {
        if (sender.edges == .right) {
            let tabController = self.tabBarController as! RouterTabBarController
            tabController.selectedIndex = 1
        }
    }
}

extension CreateViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        self.capturedImage = UIImage.init(data: imageData! , scale: 1.0)
        self.performSegue(withIdentifier: "previewSegue", sender: self)
    }
}
