//
//  ModelsManager.swift
//  ARWig
//
//  Created by Esteban Arrúa on 11/20/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import ARKit

class ModelsManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = ModelsManager()
    
    // MARK: - Properties
    
    private var models: [SCNNode] = []
    
    func getNode(forIndex index: Int) -> SCNNode {
        if index >= models.count {
            guard let hattrickScene = SCNScene(named: "art.scnassets/hattrick.dae") else {
                fatalError("Fail hattrickScene load.")
            }
            
            guard let hattrickNode = hattrickScene.rootNode.childNode(withName: "Hattrick", recursively: true) else {
                fatalError("Hattrick node doesn't exist.")
            }
            
            hattrickNode.removeFromParentNode()
            models.append(hattrickNode)
            return hattrickNode
        } else {
            return models[index]
        }
    }
    
    func releaseNodes(fromIndex index: Int) -> [SCNNode] {
        var nodes: [SCNNode] = []
        
        for i in index..<models.count {
            models[i].removeFromParentNode()
            nodes.append(models[i])
        }
        
        return nodes
    }
    
}
