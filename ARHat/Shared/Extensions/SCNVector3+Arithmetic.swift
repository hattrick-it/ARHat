//
//  SCNVector3+Arithmetic.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/21/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    
    func normalized() -> SCNVector3 {
        let lenght = self.lenght()
        return SCNVector3Make(x/lenght, y/lenght, z/lenght)
    }
    
    func lenght() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    static func crossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x).normalized()
    }
    
    static func diference(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func angle(left: SCNVector3, right: SCNVector3) -> Float {
        let cosAngle = dotProduct(left: left, right: right) / left.lenght() * right.lenght()
        return acos(cosAngle)
    }
    
    static func dotProduct(left: SCNVector3, right: SCNVector3) -> Float {
        return left.x * right.x + left.y * right.y + left.z * right.z
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func += (left: inout SCNVector3, right: SCNVector3) {
        left = left + right
    }
    
    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }
    
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
    
    static func distance(from left: SCNVector3, to right: SCNVector3) -> Float {
        let xDist = (left.x - right.x)
        let yDist = (left.y - right.y)
        let zDist = (left.z - right.z)
        return sqrt(pow(xDist, 2) + pow(yDist, 2) + pow(zDist, 2))
    }
    
    static func midpoint(of points: [SCNVector3]) -> SCNVector3 {
        var vector = SCNVector3Make(0, 0, 0)
        
        guard points.count != 0 else {
            return SCNVector3Zero
        }
        
        for point in points {
            vector += point
        }
        
        vector = vector / Float(points.count)
        return vector
    }
    
}
