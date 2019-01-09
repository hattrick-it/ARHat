//
//  CGPoint+Arithmetic.swift
//  ARWig
//
//  Created by Esteban Arrúa on 12/18/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    static func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(pow(xDist, 2) + pow(yDist, 2)))
    }
    
}
