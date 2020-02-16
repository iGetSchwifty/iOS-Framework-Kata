//
//  AdServiceTests.swift
//  PollfishSDKTests
//
//  Created by Jeff on 1/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import XCTest
@testable import PollfishSDK

class AdServiceTests: XCTestCase {
    func test_isAdvertisingTrackingEnabled_false() {
        let mockProtocol = MockAdService(trackingEnabled: false, adID: UUID())
        XCTAssert(AdService.advertisingID(mockProtocol) == nil)
    }
    
    func test_isAdvertisingTrackingEnabled_true() {
        let mockUUID = UUID()
        let mockProtocol = MockAdService(trackingEnabled: true, adID: mockUUID)
        XCTAssert(AdService.advertisingID(mockProtocol) == mockUUID)
    }
}
