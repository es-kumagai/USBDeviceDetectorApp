//
//  ActivityLog.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

import AppKit

func activityLog(_ message: String) {

    let log = ActivityLog(message: message)
    
    ActivityLogNotification(log: log).post(to: NSWorkspace.shared.notificationCenter)
}

func activityLog(label: String, @ActivityLogOptionDescriptions options: () -> String) {
    
    activityLog("\(label):\n\(options())")
}

struct ActivityLog {
    
    var message: String
}

extension ActivityLog {
    
    init(_ message: String) {
        
        self.init(message: message)
    }
}
