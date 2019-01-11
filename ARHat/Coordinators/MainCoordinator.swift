//
//  MainCoordinator.swift
//  ArWig
//
//  Created by Esteban Arrúa on 11/9/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MainCoordinator: BaseCoordinator<Void> {
    
    let window: UIWindow
    var navigationController: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let faceDetectViewController = FaceDetectViewController()
        
        navigationController = UINavigationController(rootViewController: faceDetectViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        navigationController.setNavigationBarHidden(true, animated: true)
        
        return Observable.never()
    }
    
}
