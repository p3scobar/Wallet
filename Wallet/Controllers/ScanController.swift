//
//  ScanController.swift
//  coins
//
//  Created by Hackr on 1/6/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import AVFoundation
import UIKit
import Pulley

class ScanController: UIViewController {
    
    private var scans: Int = 0
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var isSessionRunning = false
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private var setupResult: SessionSetupResult = .success
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var videoDeviceInput: AVCaptureDeviceInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        sessionQueue.async {
            self.setupCamera()
        }
    }
    
    @objc func handleCancel() {
        stopCamera()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scans = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scans = 0
        stopCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }


    func startCamera() {
        sessionQueue.async { [unowned self] in
            if !self.isSessionRunning {
                if let connection = self.previewLayer?.connection {
                    connection.isEnabled = true
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                }
            }
        }
    }
    
    func stopCamera() {
        sessionQueue.async { [unowned self] in
            if self.isSessionRunning {
                if let connection = self.previewLayer?.connection {
                    connection.isEnabled = false
                    self.session.stopRunning()
                    self.isSessionRunning = self.session.isRunning
                }
            }
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    func removeCameraLayer() {
        DispatchQueue.main.async {
            self.previewLayer?.removeFromSuperlayer()
        }
    }
    
    
    func addCameraLayer() {
        DispatchQueue.main.async {
            if self.previewLayer != nil {
                self.view.layer.addSublayer(self.previewLayer!)
            }
        }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        
        let metadataObject = metadataObjects.first
        let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
        let stringValue = readableObject.stringValue!
        found(code: stringValue)
    }
    
    
    func found(code: String) {
        UIDevice.vibrate()
        pushAmountController(code)
        
    }
    
    func pushAmountController(_ publicKey: String) {
        
        
//        if let pulley = parent as? PulleyViewController,
//            let wallet = pulley.drawerContentViewController as? WalletNavigationController {
//            wallet.pushViewController(vc, animated: true)
//        }

        NotificationCenter.default.post(name: Notification.Name("scan"), object: nil, userInfo: ["code":publicKey])
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension ScanController: PulleyPrimaryContentControllerDelegate {
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if drawer.drawerPosition == PulleyPosition.open {
            stopCamera()
            removeCameraLayer()
        } else {
            startCamera()
            addCameraLayer()
        }
    }
}



extension ScanController: AVCaptureMetadataOutputObjectsDelegate {

    
    func setupCamera() {
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (session.canAddInput(videoDeviceInput)) {
            session.addInput(videoDeviceInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
        } else {
            failed()
            return
        }
        
        DispatchQueue.main.async {
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            self.previewLayer?.frame = self.view.layer.bounds
            self.previewLayer?.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.previewLayer!)
        }
        
    }
    
}
