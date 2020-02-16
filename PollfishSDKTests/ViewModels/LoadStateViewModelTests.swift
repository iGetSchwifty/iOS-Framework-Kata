//
//  LoadStateViewModelTests.swift
//  PollfishSDKTests
//
//  Created by Jeff on 1/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import XCTest
@testable import PollfishSDK

class LoadStateViewModelTests: XCTestCase {

    private var testInstance: LoadStateViewModel!
    
    override func setUp() {
        testInstance = LoadStateViewModel()
    }
    
    func test_state_initalize() {
        XCTAssert(testInstance.currentState == .initalize)
    }
    
    func test_state_error() {
        XCTAssert(testInstance.currentState == .initalize)
        testInstance.errorState()
        XCTAssert(testInstance.currentState == .failed)
    }
    
    func test_state_errorAfterSuccess() {
        XCTAssert(testInstance.currentState == .initalize)
        testInstance.incrementSuccess()
        testInstance.errorState()
        XCTAssert(testInstance.currentState == .failed)
    }
    
    func test_state_inProcess() {
        XCTAssert(testInstance.currentState == .initalize)
        testInstance.incrementSuccess()
        XCTAssert(testInstance.currentState == .inProcess)
    }
    
    func test_state_success() {
        XCTAssert(testInstance.currentState == .initalize)
        testInstance.incrementSuccess()
        testInstance.incrementSuccess()
        XCTAssert(testInstance.currentState == .success)
    }
}
