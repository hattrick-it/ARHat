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
    
    func getFacesPaths(_ faceObservations: [VNFaceObservation], resolution: CGSize) -> [CGMutablePath] {
        let faceRectanglePath = CGMutablePath()
        let faceLandmarksPath = CGMutablePath()
        
        for faceObservation in faceObservations {
            addIndicators(to: faceRectanglePath, faceLandmarksPath: faceLandmarksPath, for: faceObservation, displaySize: resolution)
        }
        
        return [faceRectanglePath, faceLandmarksPath]
    }
    
    fileprivate func addIndicators(to faceRectanglePath: CGMutablePath, faceLandmarksPath: CGMutablePath, for faceObservation: VNFaceObservation, displaySize: CGSize) {
        let faceBounds = VNImageRectForNormalizedRect(faceObservation.boundingBox, Int(displaySize.width), Int(displaySize.height))
        faceRectanglePath.addRect(faceBounds)
        
        if let landmarks = faceObservation.landmarks {
            // Landmarks are relative to -- and normalized within --- face bounds
            let affineTransform = CGAffineTransform(translationX: faceBounds.origin.x, y: faceBounds.origin.y)
                .scaledBy(x: faceBounds.size.width, y: faceBounds.size.height)
            
            // Treat eyebrows and lines as open-ended regions when drawing paths.
            let openLandmarkRegions: [VNFaceLandmarkRegion2D?] = [
                landmarks.leftEyebrow,
                landmarks.rightEyebrow,
                landmarks.faceContour,
                landmarks.noseCrest,
                landmarks.medianLine
            ]
            for openLandmarkRegion in openLandmarkRegions where openLandmarkRegion != nil {
                self.addPoints(in: openLandmarkRegion!, to: faceLandmarksPath, applying: affineTransform, closingWhenComplete: false)
            }
            
            // Draw eyes, lips, and nose as closed regions.
            let closedLandmarkRegions: [VNFaceLandmarkRegion2D?] = [
                landmarks.leftEye,
                landmarks.rightEye,
                landmarks.outerLips,
                landmarks.innerLips,
                landmarks.nose
            ]
            for closedLandmarkRegion in closedLandmarkRegions where closedLandmarkRegion != nil {
                self.addPoints(in: closedLandmarkRegion!, to: faceLandmarksPath, applying: affineTransform, closingWhenComplete: true)
            }
        }
    }
    
    fileprivate func addPoints(in landmarkRegion: VNFaceLandmarkRegion2D, to path: CGMutablePath, applying affineTransform: CGAffineTransform, closingWhenComplete closePath: Bool) {
        let pointCount = landmarkRegion.pointCount
        if pointCount > 1 {
            let points: [CGPoint] = landmarkRegion.normalizedPoints
            path.move(to: points[0], transform: affineTransform)
            path.addLines(between: points, transform: affineTransform)
            if closePath {
                path.addLine(to: points[0], transform: affineTransform)
                path.closeSubpath()
            }
        }
    }
    
}
