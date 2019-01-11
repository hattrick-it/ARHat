//
//  SCNNode+Animations.swift
//  ARWig
//
//  Created by Esteban Arrúa on 12/17/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    
    func infiniteRotation(x: Float, y: Float, z: Float, duration: TimeInterval) {
        let rotateOne = SCNAction.rotateBy(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: duration)
        let repeatForever = SCNAction.repeatForever(rotateOne)
        self.runAction(repeatForever)
    }
    
}
