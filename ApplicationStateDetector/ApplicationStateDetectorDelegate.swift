//
//  ApplicationStateDetectorDelegate.swift
//  ApplicationStateDetector
//  
//  Created by Tomohiro Kumagai on 2022/10/07
//  
//

import Foundation

@objc
public protocol ApplicationStateDetectorDelegate {
    
    @objc optional func applicationStateDetectorApplicationDidLaunch(_ detector: ApplicationStateDetector)
    @objc optional func applicationStateDetectorWillPowerOff(_ detector: ApplicationStateDetector)
    @objc optional func applicationStateDetectorWillSleep(_ detector: ApplicationStateDetector)
    @objc optional func applicationStateDetectorDidWake(_ detector: ApplicationStateDetector)
    @objc optional func applicationStateDetectorScreenDidSleep(_ detector: ApplicationStateDetector)
    @objc optional func applicationStateDetectorScreenDidWake(_ detector: ApplicationStateDetector)
}
