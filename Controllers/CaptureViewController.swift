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

class CaptureViewController: UIViewController {

    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var capturedImage: UIImage?
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.isNavigationBarHidden = true
        
        var captureSession: AVCaptureSession?
        var videoPreviewLayer: AVCaptureVideoPreviewLayer?
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCaptureBtnTapped(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto

        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "previewSegue") {
            guard let controller = segue.destination as? PreviewViewController else {
                return
            }
            controller.image = self.capturedImage
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CaptureViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("photo output")
        let imageData = photo.fileDataRepresentation()
        self.capturedImage = UIImage.init(data: imageData! , scale: 1.0)
        self.performSegue(withIdentifier: "previewSegue", sender: self)
    }
}


/*
 func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
 
 guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
 print("Error capturing photo: \(String(describing: error))")
 return
 }
 
 guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
 return
 }
 
 let capturedImage = UIImage.init(data: imageData , scale: 1.0)
 if let image = capturedImage {
 UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 }
 }
 */
