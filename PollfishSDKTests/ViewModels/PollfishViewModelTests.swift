//
//  PollfishSDKTests.swift
//  PollfishSDKTests
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import WebKit
import XCTest
@testable import PollfishSDK

//
//  Note: this test kinda blurs the lines between what is considered UI/Unit testing..
//

class PollfishViewModelTests: XCTestCase {
    
    private var testInstance: PollfishViewModel!
    private var webView: WKWebView!
    private var webNav: WKNavigation!

    override func setUp() {
        let params = PollfishParams()
        testInstance = PollfishViewModel(apiKey: "Fake_API_Key",
                                         params: params,
                                         openCallback: nil,
                                         closeCallback: nil)
        
        webView = WKWebView()
        webNav = WKNavigation()
    }
    
    func test_remaingParamsToSendOnClose() {
        let promise = expectation(description: "Params on close")
        var params = PollfishParams()
        var didFireOpen = false
        params.testStrings = ["1", "2", "3", "4", "5"]
        testInstance = PollfishViewModel(apiKey: "Fake_API_Key",
                                         params: params,
                                         openCallback: { [weak self] in
                                            didFireOpen = true
                                            self?.testInstance.hidePoll()
                                         },
                                         closeCallback: { closeParams in
                                            XCTAssert(closeParams.count == 3)
                                            XCTAssert(closeParams[0] == "3")
                                            XCTAssert(closeParams[1] == "4")
                                            XCTAssert(closeParams[2] == "5")
                                            promise.fulfill()
                                         })
        testInstance.showPoll()
        wait(for: [promise], timeout: 1)
        XCTAssert(didFireOpen == true)
    }
    
    func test_closeButton() {
        XCTAssert(testInstance.closeButton.isUserInteractionEnabled == true)
        XCTAssert(testInstance.closeButton.translatesAutoresizingMaskIntoConstraints == false)
        XCTAssert(testInstance.closeButton.titleLabel?.text == "X")
        XCTAssert(testInstance.closeButton.titleLabel?.textColor == .black)
        XCTAssert(testInstance.closeButton.titleLabel?.font == UIFont.boldSystemFont(ofSize: 42))
        XCTAssert(testInstance.closeButton.accessibilityIdentifier == "PollfishWebView_Close")
    }
    
    func test_adIDLabel() {
        XCTAssert(testInstance.adIDLabel.translatesAutoresizingMaskIntoConstraints == false)
        XCTAssert(testInstance.adIDLabel.textColor == .red)
        XCTAssert(testInstance.adIDLabel.text == "#_AD_ID_")
        XCTAssert(testInstance.adIDLabel.accessibilityIdentifier == "AD_ID")
    }
    
    func test_param1() {
        XCTAssert(testInstance.param1.translatesAutoresizingMaskIntoConstraints == false)
        XCTAssert(testInstance.param1.textColor == .red)
        XCTAssert(testInstance.param1.text == "#param1")
    }
    
    func test_param2() {
        XCTAssert(testInstance.param2.translatesAutoresizingMaskIntoConstraints == false)
        XCTAssert(testInstance.param2.textColor == .red)
        XCTAssert(testInstance.param2.text == "#param2")
    }
    
    func test_param1_text() {
        var params = PollfishParams()
        params.testStrings = ["1", "2", "3", "4", "5"]
        testInstance = PollfishViewModel(apiKey: "Fake_API_Key",
                                         params: params,
                                         openCallback: nil,
                                         closeCallback: nil)
        XCTAssert(testInstance.param1.translatesAutoresizingMaskIntoConstraints == false)
        XCTAssert(testInstance.param1.textColor == .red)
        XCTAssert(testInstance.param1.text == "1")
    }
    
    func test_param2_text() {
        var params = PollfishParams()
        params.testStrings = ["1", "2", "3", "4", "5"]
        testInstance = PollfishViewModel(apiKey: "Fake_API_Key",
                                         params: params,
                                         openCallback: nil,
                                         closeCallback: nil)
        XCTAssert(testInstance.param2.translatesAutoresizingMaskIntoConstraints == false)
        XCTAssert(testInstance.param2.textColor == .red)
        XCTAssert(testInstance.param2.text == "2")
    }
    
    func test_urlRequest() {
        let myURL = URL(string:"https://www.pollfish.com")
        let request = URLRequest(url: myURL!)
        XCTAssert(testInstance.urlRequest() == request)
    }
    
    func test_fetchAdID_error() {
        let promise = expectation(description: "Failed To fetch")
        XCTAssert(testInstance.currentState == .initalize)
        let mockService = MockAdService(trackingEnabled: false, adID: UUID())
        testInstance.fetchAdID(mockService)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssert(self.testInstance.currentState == .failed)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_fetchAdID_inProcess() {
        let promise = expectation(description: "In process")
        XCTAssert(testInstance.currentState == .initalize)
        let mockService = MockAdService(trackingEnabled: true, adID: UUID())
        testInstance.fetchAdID(mockService)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(self.testInstance.currentState == .inProcess)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_fetchAdID_success() {
        testInstance.incrementSuccess()
        let promise = expectation(description: "Success")
        XCTAssert(testInstance.currentState == .inProcess)
        let mockService = MockAdService(trackingEnabled: true, adID: UUID())
        testInstance.fetchAdID(mockService)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssert(self.testInstance.currentState == .success)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_showPoll() {
        let newFrame = CGRect(x: 42, y: 42, width: 42, height: 42)
        let promise = expectation(description: "Show Poll")
        testInstance.updateView(frame: newFrame)
        testInstance.initWebView()
        testInstance.showPoll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssert(self.testInstance.webView?.frame == self.testInstance.onScreenFrame)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_init_pollHidden() {
        XCTAssert(testInstance.webView?.frame == testInstance.offScreenFrame)
    }
    
    func test_showThenHidePoll() {
        let newFrame = CGRect(x: 42, y: 42, width: 42, height: 42)
        let promise = expectation(description: "Hide Poll")
        testInstance.updateView(frame: newFrame)
        testInstance.initWebView()
        testInstance.showPoll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssert(self.testInstance.webView?.frame == self.testInstance.onScreenFrame)
            self.testInstance.hidePoll()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssert(self.testInstance.webView?.frame == self.testInstance.offScreenFrame)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 1.1)
    }
    
    func test_initWebView() {
        let newFrame = CGRect(x: 42, y: 42, width: 42, height: 42)
        testInstance.updateView(frame: newFrame)
        XCTAssert(testInstance.webView == nil)
        testInstance.initWebView()
        XCTAssert(testInstance.webView != nil)
        XCTAssert(testInstance.webView?.frame == testInstance.offScreenFrame)
        XCTAssert(testInstance.webView?.accessibilityIdentifier == "PollfishWebView")
    }
    
    func test_WKNavigationDelegate_decisionHandler() {
        let promise = expectation(description: "Policy To Allow")
        
        testInstance.webView(WKWebView(), decidePolicyFor: WKNavigationAction()) { policy in
            if policy == .allow {
                promise.fulfill()
            } else {
                XCTFail()
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_WKNavigationDelegate_withError() {
        testInstance.webView(webView, didFail: webNav, withError: TestError.fail)
        XCTAssert(testInstance.currentState == .failed)
    }
    
    func test_WKNavigationDelegate_inProcess() {
        testInstance.webView(webView, didFinish: webNav)
        XCTAssert(testInstance.currentState == .inProcess)
    }
    
    func test_WKNavigationDelegate_success() {
        testInstance.incrementSuccess()
        testInstance.webView(webView, didFinish: webNav)
        XCTAssert(testInstance.currentState == .success)
    }
}


fileprivate enum TestError: Error {
    case fail
}
