//
//  BaseViewModel.swift
//  ArWig
//
//  Created by Esteban Arrúa on 11/9/18.
//  Copyright © 2018 Hattrick It. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    let setErrorMessage: AnyObserver<String>
    
    // MARK: - Outputs
    
    let errorMessage: Observable<String>
    
    // MARK: - Setup
    
    init() {
        let _setErrorMessage = PublishSubject<String>()
        setErrorMessage = _setErrorMessage.asObserver()
        errorMessage = _setErrorMessage.asObservable()
    }
    
}
