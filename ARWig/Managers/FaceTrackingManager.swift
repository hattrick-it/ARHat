//
//  FaceTrackingManager.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/12/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import Vision

class FaceTrackingManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = FaceTrackingManager()
    
    // MARK: - Properties
    
    private let faceDetectionRequest: VNDetectFaceLandmarksRequest
    private let faceDetectionHandler: VNSequenceRequestHandler
    
    init() {
        faceDetectionRequest = VNDetectFaceLandmarksRequest()
        faceDetectionHandler = VNSequenceRequestHandler()
    }
    
    func trackFaces(pixelBuffer: CVPixelBuffer) -> [VNFaceObservation] {
        try? faceDetectionHandler.perform([faceDetectionRequest], on: pixelBuffer, orientation: .right)
        guard let bondingBoxes = faceDetectionRequest.results as? [VNFaceObservation] else {
           return []
        }
        
        return bondingBoxes
    }
    
    func getFacesPaths(_ faceObservations: [VNFaceObservation], resolution: CGSize) -> [Face2D] {
        var faces: [Face2D?] = []
        
        for faceObservation in faceObservations {
            faces.append(Face2D(for: faceObservation, displaySize: resolution))
        }
        
        return faces.compactMap({ $0 })
    }
    
}
