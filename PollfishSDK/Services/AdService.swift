//
//  AdService.swift
//  Pollfish SDK
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import AdSupport

internal class AdService {
    internal static func advertisingID(_ instance: AdSupportProtocol? = nil) -> UUID? {
        var service: AdSupportProtocol
        if let instance = instance {
            service = instance
        } else {
            service = AppleAdSupport()
        }
        
        return from(service)
    }
    
    
    private static func from(_ instance: AdSupportProtocol) -> UUID? {
        guard instance.isAdvertisingTrackingEnabled else { return nil }
        return instance.advertisingIdentifier
    }
}

fileprivate struct AppleAdSupport: AdSupportProtocol {
    var isAdvertisingTrackingEnabled: Bool {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    var advertisingIdentifier: UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
}
