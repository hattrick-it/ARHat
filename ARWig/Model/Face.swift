//
//  Face.swift
//  ARWig
//
//  Created by Esteban Arrúa on 12/18/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import CoreGraphics
import SceneKit

class Face {
    
    let max2DDistance: CGFloat = 30.0
    let max3DDistance: Float = 0.005
    let maxSamples = 10
    let outlierRatio = 0.7
    let ratio: Float = 80.0
    
    var faces2D: [Face2D] = []
    var faces3D: [Face3D] = []
    var active: Bool = true
    
    func addNewValue(face2D: Face2D, face3D: Face3D) -> Bool {
        if faces2D.isEmpty {
            faces2D.append(face2D)
            faces3D.append(face3D)
            return true
        } else {
            var minDistance = max2DDistance
            for face in faces2D {
                let distance = CGPoint.distance(from: face.btwEyes, to: face2D.btwEyes)
                if distance < minDistance {
                    minDistance = distance
                }
            }
            
            if minDistance < max2DDistance  {
                faces2D.append(face2D)
                faces3D.append(face3D)
                if (faces2D.count > maxSamples) {
                    faces2D.removeFirst()
                    faces3D.removeFirst()
                }
                return true
            } else {
                return false
            }
        }
    }
    
    func getPosition() -> SCNVector3 {
        var divisor = 0
        var vector = SCNVector3Make(0, 0, 0)
        
        for (index, face) in faces3D.enumerated() {
            if isOutlier(index: index) {
                divisor += 1
                vector += face.btwEyes
            } else {
                divisor += Int(ratio)
                vector += face.btwEyes * ratio
            }
        }
        
        vector = vector / Float(divisor)
        return vector
    }
    
    func getFaceSize() -> Float {
        var divisor = 0
        var size: Float = 0
        
        for (index, face) in faces3D.enumerated() {
            if isOutlier(index: index) {
                divisor += 1
                size += face.getFaceSize()
            } else {
                divisor += Int(ratio)
                size += face.getFaceSize() * ratio
            }
        }
        
        return size / Float(divisor)
    }
    
    fileprivate func isOutlier(index: Int) -> Bool {
        var pointDiferents = 0
        
        for face in faces3D {
            let distance = SCNVector3.distance(from: faces3D[index].btwEyes, to: face.btwEyes)
            if distance >= max3DDistance {
                pointDiferents += 1
            }
        }
        
        return Float(pointDiferents) > Float(maxSamples) * Float(outlierRatio)
    }
    
}
