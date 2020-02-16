//
//  MockAdSupport.swift
//  PollfishSDKTests
//
//  Created by Jeff on 1/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
@testable import PollfishSDK

public class MockAdService: AdSupportProtocol {
    public var isAdvertisingTrackingEnabled: Bool
    public var advertisingIdentifier: UUID
    
    init(trackingEnabled: Bool, adID: UUID) {
        isAdvertisingTrackingEnabled = trackingEnabled
        advertisingIdentifier = adID
    }
}
