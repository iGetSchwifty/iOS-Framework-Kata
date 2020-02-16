//
//  AdServiceProtocol.swift
//  Pollfish SDK
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

public protocol AdSupportProtocol {
    var isAdvertisingTrackingEnabled: Bool { get }
    var advertisingIdentifier: UUID { get }
}
