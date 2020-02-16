//
//  Notification_Name+Pollfish.swift
//  PollfishSDK
//
//  Created by Tacenda on 1/25/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import UIKit

public extension Notification.Name {
    static var pollfishSurveyNotAvailable = NSNotification.Name(rawValue: "PollfishSurveyNotAvailable")
    static var pollfishUserRejectedSurvey = NSNotification.Name(rawValue: "PollfishUserRejectedSurvey")
    static var pollfishSurveyReceived = NSNotification.Name(rawValue: "PollfishSurveyReceived")
    static var pollfishSurveyCompleted = NSNotification.Name(rawValue: "PollfishSurveyCompleted")
    static var pollfishOpened = NSNotification.Name(rawValue: "PollfishOpened")
    static var pollfishClosed = NSNotification.Name(rawValue: "PollfishClosed")
    static var pollfishUserNotEligible = NSNotification.Name(rawValue: "PollfishUserNotEligible")
}
