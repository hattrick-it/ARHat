//
//  Face3D.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/15/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import ARKit

class Face3D {
    
    // MARK: - Properties
    
    let btwEyes: SCNVector3
    let chin: SCNVector3
    
    init?(withFace2D face2D: Face2D, view: ARSCNView) {
        let hitTestBtwEyes = view.hitTest(face2D.btwEyes, types: [.featurePoint])
        let hitTestChin = view.hitTest(face2D.chin, types: [.featurePoint])
        
        guard let btwEyesTransform = hitTestBtwEyes.first?.worldTransform, let chinTransform = hitTestChin.first?.worldTransform else {
            return nil
        }
        
        btwEyes = SCNVector3(btwEyesTransform.columns.3.x, btwEyesTransform.columns.3.y, btwEyesTransform.columns.3.z)
        chin = SCNVector3(chinTransform.columns.3.x, chinTransform.columns.3.y, chinTransform.columns.3.z)
    }
    
    func getFaceSize() -> Float {
        let radius = SCNVector3.diference(left: btwEyes, right: chin).lenght()
        return radius
    }
    
}
