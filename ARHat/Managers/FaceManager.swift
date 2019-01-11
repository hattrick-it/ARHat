//
//  FaceManager.swift
//  ARWig
//
//  Created by Esteban Arrúa on 12/18/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation

class FaceManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = FaceManager()
    
    // MARK: - Properties
    
    var lastFaces: [Face] = []
    
    func addNewFace(face2D: Face2D, face3D: Face3D) {
        for face in lastFaces {
            if face.addNewValue(face2D: face2D, face3D: face3D) {
                face.active = true
                return
            }
        }
        let face = Face()
        _ = face.addNewValue(face2D: face2D, face3D: face3D)
        lastFaces.append(face)
    }
    
    func deleteUnusedFaces() {
        lastFaces.removeAll(where: { !$0.active })
        for face in lastFaces {
            face.active = false
        }
    }
    
}

