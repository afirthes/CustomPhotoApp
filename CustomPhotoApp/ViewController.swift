//
//  ViewController.swift
//  CustomPhotoApp
//
//  Created by Afir Thes on 09.09.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var capturedImageThumbnail: UIButton!
    
    let captureSession = AVCaptureSession()
    
    var photoOutput = AVCapturePhotoOutput()
    
    var activeInput: AVCaptureDeviceInput!
    
    var isSessionSetup = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        captureButton.layer.cornerRadius = captureButton.layer.frame.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func startSession() {
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    func stopSession()  {
        DispatchQueue.main.async {
            self.captureSession.stopRunning()
        }
    }
    
    func setupSession() -> Bool {
        
        captureSession.beginConfiguration() // atomically
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo // high - for video
        
        // looking for default capture device for video
        let camera = AVCaptureDevice.default(for: AVMediaType.video)!
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            } else {
                print("Was not able to add input device!")
                captureSession.commitConfiguration()
                return false
            }
        } catch  {
            print("Was not able to add input device!")
            captureSession.commitConfiguration()
            return false
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            photoOutput.isHighResolutionCaptureEnabled = true
        } else {
            print("Was not able to create photo output!")
            captureSession.commitConfiguration()
            return false
        }
        
        captureSession.commitConfiguration()
        
        self.isSessionSetup = true
        
        return true
    }

    @IBAction func capture(_ sender: Any) {
        
    }
    
    @IBAction func showCapturedImage(_ sender: Any) {
    }
    
}

