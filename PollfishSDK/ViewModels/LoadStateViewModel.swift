//
//  PollfishLoadState.swift
//  PollfishSDK
//
//  Created by Tacenda on 1/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

internal class LoadStateViewModel {
    private var state: LoadState = .initalize
    func incrementSuccess() {
        switch state {
        case .initalize:
            state = .inProcess
        case .inProcess:
            state = .success
        default:
            break
        }
    }
    
    func errorState() {
        state = .failed
    }
    
    var currentState: LoadState {
        return state
    }
}

internal enum LoadState {
    case initalize
    case inProcess
    case failed
    case success
}
