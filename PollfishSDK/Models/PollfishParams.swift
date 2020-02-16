//
//  PollfishParams.swift
//  Pollfish SDK
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

public struct PollfishParams {
    public var indicatorPosition: PollfishPosition = .middleRight
    public var indicatorPadding: Int = 0
    public var releaseMode: Bool = false
    public var offerwallMode: Bool = false
    public var rewardMode: Bool = false
    public var requestUUID: String?
    
    public var testStrings: [String]
    
    public init() {
        testStrings = []
    }
    
    public init(attributes: [String]) {
        testStrings = attributes
    }
}
