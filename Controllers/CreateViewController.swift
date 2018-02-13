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
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.isNavigationBarHidden = true
        let tabController = self.tabBarController as! RouterTabBarController
        self.user = tabController.user
        
        print(self.user?._id ?? "no user id")
        
        #if !SIMULATOR
            self.setupCamera()
        #endif

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCamera() {
        var captureSession: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //flash off
        do {
            let abv = try captureDevice?.lockForConfiguration()
        } catch {
            print("aaaa")
        }
        captureDevice?.torchMode = AVCaptureDevice.TorchMode.off
        captureDevice?.unlockForConfiguration()

        //flash off end
        
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
        photoSettings.flashMode = .auto

        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
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
    
    @IBAction func unwindToCreate(segue: UIStoryboardSegue) {}
    
    func prepare(completionHandler: @escaping (Error?) -> Void) { }

}

extension CreateViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        self.capturedImage = UIImage.init(data: imageData! , scale: 1.0)
        self.performSegue(withIdentifier: "previewSegue", sender: self)
    }
}
