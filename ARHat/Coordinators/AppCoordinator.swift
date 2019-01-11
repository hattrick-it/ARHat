//
//  AppCoordinator.swift
//  ArWig
//
//  Created by Esteban Arrúa on 11/9/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        showMainScreen(window: window)
            .do(onNext: { [weak self] (_) in
                _ = self?.start()
            }).subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func showMainScreen(window: UIWindow) -> Observable<Void> {
        let mainCoordinator = MainCoordinator(window: window)
        return coordinate(to: mainCoordinator)
    }
    
}
