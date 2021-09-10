//
//  ViewController.swift
//  CustomPhotoApp
//
//  Created by Afir Thes on 09.09.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var capturedImageThumbnail: UIButton!
    
    let captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    var activeInput: AVCaptureDeviceInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var isSessionSetup = false
    var capturedImage: Data!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captureButton.layer.cornerRadius = captureButton.layer.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isSessionSetup {
            if setupSession() {
                setupPreview()
                startSession()
            }
        } else {
            if !captureSession.isRunning {
                startSession()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            stopSession()
        }
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
    
    func setupPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
    }

    @IBAction func capture(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = AVCaptureDevice.FlashMode.on
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func showCapturedImage(_ sender: Any) {
        guard let capturedImage = capturedImage else { return }
        performSegue(withIdentifier: "CapturedImageSegue", sender: capturedImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CapturedImageSegue" {
            let destinationVC = segue.destination as! CapturedImageViewController
            destinationVC.capturedImage = sender as? Data
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else {
            print("Error capture process: \(String(describing: error?.localizedDescription))")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Unable to create image data")
            return
        }
        
        capturedImage = imageData
        capturedImageThumbnail.setBackgroundImage(UIImage(data: capturedImage), for: .normal)
    }
    
}

