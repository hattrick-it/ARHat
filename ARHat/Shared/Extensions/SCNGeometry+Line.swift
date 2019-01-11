//
//  SCNGeometry+Line.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/22/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import SceneKit

extension SCNGeometry {
    
    static func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
    
}
