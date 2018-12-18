//
//  FaceDetectViewController.swift
//  ArWig
//
//  Created by Esteban Arrúa on 11/9/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import RxSwift
import Vision
import ARKit

class FaceDetectViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var previewView: ARSCNView!
    
    // MARK: - Properties
    let faceProportion: Float = 1.5
    let modelScale: Float = 140
    
    private let disposeBag = DisposeBag()
    
    var faces: [Face2D] = []
    var timer: Timer!
    var lastLineNode: [SCNNode] = []
    
    // MARK: - Setup
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        previewView.scene = scene
        previewView.automaticallyUpdatesLighting = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] _ in
            self?.faceTracking()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        previewView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        previewView.session.pause()
    }
    
    fileprivate func faceTracking() {
        guard let pixelBuffer = previewView.session.currentFrame?.capturedImage else {
            return
        }
        
        let bondingBoxes = FaceTrackingManager.sharedInstance.trackFaces(pixelBuffer: pixelBuffer)
        
        let resolution = CGSize(width: previewView.bounds.width, height: previewView.bounds.height)
        faces = FaceTrackingManager.sharedInstance.getFacesPaths(bondingBoxes, resolution: resolution)
        
        var index = 0
        for face in self.faces {
            if let face3D = Face3D(withFace2D: face, view: self.previewView) {
                let hattrickNode = ModelsManager.sharedInstance.getNode(forIndex: index)
                if hattrickNode.parent == nil {
                    hattrickNode.position = face3D.btwEyes
                    hattrickNode.position.y += face3D.getFaceSize() * faceProportion
                    hattrickNode.infiniteRotation(x: 0, y: Float.pi, z: 0, duration: 5.0)
                } else {
                    let move = SCNAction.moveBy(x: CGFloat(face3D.btwEyes.x - hattrickNode.position.x), y: CGFloat(face3D.btwEyes.y + face3D.getFaceSize() * faceProportion - hattrickNode.position.y), z: CGFloat(face3D.btwEyes.z - hattrickNode.position.z), duration: 0.05)
                    hattrickNode.runAction(move)
                }
                hattrickNode.scale = SCNVector3(face3D.getFaceSize() * modelScale, face3D.getFaceSize() * modelScale, face3D.getFaceSize() * modelScale)
                
                self.previewView.scene.rootNode.addChildNode(hattrickNode)
                
                index += 1
            }
        }
        
        let releasedNodes = ModelsManager.sharedInstance.releaseNodes(fromIndex: index)
        for node in releasedNodes {
            node.removeAllActions()
        }
    }
    
}
