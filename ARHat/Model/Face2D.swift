//
//  Face2D.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/15/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import Vision

class Face2D {
    
    // MARK: - Properties
    
    let btwEyes: CGPoint
    let chin: CGPoint
    
    // MARK: - Setup
    
    init(btwEyes: CGPoint, chin: CGPoint) {
        self.btwEyes = btwEyes
        self.chin = chin
    }
    
    init?(for faceObservation: VNFaceObservation, displaySize: CGSize) {
        let faceBounds = VNImageRectForNormalizedRect(faceObservation.boundingBox, Int(displaySize.width), Int(displaySize.height))
        
        let affineTransform = CGAffineTransform(translationX: faceBounds.origin.x, y: faceBounds.origin.y)
            .scaledBy(x: faceBounds.size.width, y: faceBounds.size.height)
        
        guard let landmarks = faceObservation.landmarks else {
            return nil
        }
        
        guard let medianLineRegion = landmarks.medianLine, let faceContourRegion = landmarks.faceContour else {
            return nil
        }
        
        let medianLinePoints = medianLineRegion.normalizedPoints
        
        if medianLinePoints.count > 0 {
            var point = __CGPointApplyAffineTransform(medianLinePoints[0], affineTransform)
            point.y = displaySize.height - point.y
            self.btwEyes = point
        } else {
            return nil
        }
        
        let faceContourPoints = faceContourRegion.normalizedPoints
        if faceContourPoints.count > 0 {
            let index = (faceContourPoints.count / 2)
            var point3 = __CGPointApplyAffineTransform(faceContourPoints[index], affineTransform)
            point3.y = displaySize.height - point3.y
            self.chin = point3
        } else {
            return nil
        }
    }
    
}
