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

    public init(notificationCenter: NotificationCenter = NSWorkspace.shared.notificationCenter) {

        super.init()

        observe(notificationNamed: NSWorkspace.willPowerOffNotification, on: notificationCenter, using: deviceWillPowerOff(_:))
        observe(notificationNamed: NSWorkspace.willSleepNotification, on: notificationCenter, using: deviceWillSleep(_:))
        observe(notificationNamed: NSWorkspace.didWakeNotification, on: notificationCenter, using: deviceDidWake(_:))
        observe(notificationNamed: NSWorkspace.screensDidSleepNotification, on: notificationCenter, using: screenDidSleep(_:))
        observe(notificationNamed: NSWorkspace.screensDidWakeNotification, on: notificationCenter, using: screenDidWake(_:))
    }
    
    deinit {
        
        notificationHandlers.releaseAll()
    }
}

extension ApplicationStateDetector {

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
