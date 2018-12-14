//
//  CameraManager.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/12/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import AVKit
import UIKit

enum CameraPosition {
    case front
    case rear
}

class CameraManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = CameraManager()
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession?
    
    var currentCameraPosition: CameraPosition?
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var videoDataOutput: AVCaptureVideoDataOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var frontResolution: CGSize?
    var backResolution: CGSize?
    
    // MARK: AVCapture configuration functions
    
    func setupCamera(view: UIView, delegate: AVCaptureVideoDataOutputSampleBufferDelegate) -> CGSize? {
        createCaptureSession()
        configureCaptureDevices()
        configureDeviceInputs()
        configureVideoDataOutput(delegate: delegate)
        displayPreview(on: view)
        
        return backResolution
    }
    
    fileprivate func createCaptureSession() {
        self.captureSession = AVCaptureSession()
    }
    
    fileprivate func configureCaptureDevices() {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let cameras = session.devices
        
        guard !cameras.isEmpty else {
            return
        }
        
        for camera in cameras {
            if camera.position == .front {
                self.frontCamera = camera
                if let highestResolution = highestResolution420Format(for: camera) {
                    try! camera.lockForConfiguration()
                    camera.activeFormat = highestResolution.format
                    camera.unlockForConfiguration()
                    
                    self.frontResolution = highestResolution.resolution
                }
                
            }
            
            if camera.position == .back {
                self.rearCamera = camera
                
                try! camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                if let highestResolution = highestResolution420Format(for: camera) {
                    camera.activeFormat = highestResolution.format
                    
                    self.backResolution = highestResolution.resolution
                }
                camera.unlockForConfiguration()
            }
        }
    }
    
    fileprivate func configureDeviceInputs() {
        guard let captureSession = self.captureSession else {
            return
        }
        
        if let rearCamera = self.rearCamera {
            self.rearCameraInput = try! AVCaptureDeviceInput(device: rearCamera)
            
            if captureSession.canAddInput(self.rearCameraInput!) {
                captureSession.addInput(self.rearCameraInput!)
            }
            
            self.currentCameraPosition = .rear
        } else if let frontCamera = self.frontCamera {
            self.frontCameraInput = try! AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
            }
            
            self.currentCameraPosition = .front
        }
    }
    
    fileprivate func configureVideoDataOutput(delegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        guard let captureSession = self.captureSession else {
            return
        }
        
        self.videoDataOutput = AVCaptureVideoDataOutput()
        self.videoDataOutput?.alwaysDiscardsLateVideoFrames = true
        
        let videoDataOutputQueue = DispatchQueue(label: "com.hattrick-it.ARWig")
        self.videoDataOutput?.setSampleBufferDelegate(delegate, queue: videoDataOutputQueue)
        
        if captureSession.canAddOutput(self.videoDataOutput!) {
            captureSession.addOutput(self.videoDataOutput!)
        }
        
        self.videoDataOutput?.connection(with: .video)?.isEnabled = true
        
        if let captureConnection = self.videoDataOutput?.connection(with: .video) {
            if captureConnection.isCameraIntrinsicMatrixDeliverySupported {
                captureConnection.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
        
        captureSession.startRunning()
    }
    
    fileprivate func displayPreview(on view: UIView) {
        guard let captureSession = self.captureSession else {
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    // MARK: - ConfigureDeviceResolution
    
    fileprivate func highestResolution420Format(for device: AVCaptureDevice) -> (format: AVCaptureDevice.Format, resolution: CGSize)? {
        var highestResolutionFormat: AVCaptureDevice.Format? = nil
        var highestResolutionDimensions = CMVideoDimensions(width: 0, height: 0)
        
        for format in device.formats {
            let deviceFormat = format as AVCaptureDevice.Format
            
            let deviceFormatDescription = deviceFormat.formatDescription
            if CMFormatDescriptionGetMediaSubType(deviceFormatDescription) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
                let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)
                if (highestResolutionFormat == nil) || (candidateDimensions.width > highestResolutionDimensions.width) {
                    highestResolutionFormat = deviceFormat
                    highestResolutionDimensions = candidateDimensions
                }
            }
        }
        
        if highestResolutionFormat != nil {
            let resolution = CGSize(width: CGFloat(highestResolutionDimensions.width), height: CGFloat(highestResolutionDimensions.height))
            return (highestResolutionFormat!, resolution)
        }
        
        return nil
    }
    
}
