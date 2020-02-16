//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Tacenda on 1/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import XCTest

class ExampleUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }
    
    func test_view_showsUpHidden() {
        let app = XCUIApplication()
        app.launch()
        
        let webView = app.webViews["PollfishWebView"]
        XCTAssert(webView.frame.minX > 0)
    }
    
    func test_view_showsUpEventually() {
        let app = XCUIApplication()
        app.launch()
        
        let webView = app.webViews["PollfishWebView"]
        XCTAssert(webView.frame.minX > 0)
        
        let promise = expectation(description: "Shows up")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let webView = app.webViews["PollfishWebView"]
            let closeButton = app.buttons["PollfishWebView_Close"]
            XCTAssert(webView.frame.minX == 0)
            XCTAssert(closeButton.label == "X")
            XCTAssert(app.staticTexts["AD_ID"].label == "00000000-0000-0000-0000-000000000000")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
