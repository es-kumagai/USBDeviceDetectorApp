//
//  ApplicationStateDetector.swift
//  ApplicationStateDetector
//  
//  Created by Tomohiro Kumagai on 2022/10/07
//  
//

import AppKit
import Ocean

@objcMembers
open class ApplicationStateDetector : NSObject, NotificationObservable {

    public weak var delegate: ApplicationStateDetectorDelegate?
    public private(set) var notificationHandlers = Notification.Handlers()

    internal static var notificationCenter = NotificationCenter.default
    
    public override init() {

        super.init()

        observe(notificationNamed: NSApplication.didFinishLaunchingNotification, using: applicationDidLaunch(_:))
        observe(notificationNamed: NSWorkspace.willPowerOffNotification, using: deviceWillPowerOff(_:))
        observe(notificationNamed: NSWorkspace.willSleepNotification, using: deviceWillSleep(_:))
        observe(notificationNamed: NSWorkspace.didWakeNotification, using: deviceDidWake(_:))
        observe(notificationNamed: NSWorkspace.screensDidSleepNotification, using: screenDidSleep(_:))
        observe(notificationNamed: NSWorkspace.screensDidWakeNotification, using: screenDidWake(_:))
    }
    
    deinit {
        
        notificationHandlers.releaseAll()
    }
}

extension ApplicationStateDetector {

    open func applicationDidLaunch(_ notification: Notification) {
        
        delegate?.applicationStateDetectorApplicationDidLaunch?(self)
    }
    
    open func deviceWillPowerOff(_ notification: Notification) {
        
        delegate?.applicationStateDetectorWillPowerOff?(self)
    }
    
    open func deviceWillSleep(_ notification: Notification) {

        delegate?.applicationStateDetectorWillSleep?(self)
    }

    open func deviceDidWake(_ notification: Notification) {
        
        delegate?.applicationStateDetectorDidWake?(self)
    }

    open func screenDidSleep(_ notification: Notification) {
        
        delegate?.applicationStateDetectorScreenDidSleep?(self)
    }

    open func screenDidWake(_ notification: Notification) {
        
        delegate?.applicationStateDetectorScreenDidWake?(self)
    }
}
