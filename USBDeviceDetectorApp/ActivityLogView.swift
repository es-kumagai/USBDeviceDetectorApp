//
//  ActivityLogView.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

import Cocoa

@MainActor
class ActivityLogView: NSTextView {

    func appendLog(_ log: ActivityLog) {
        
        if !string.isEmpty {
            
            string.append("\n")
        }
        
        string.append(log.message)

        Task {
            
            try? await Task.sleep(nanoseconds: 100_000_000)
            scrollToEnd()
        }
    }
    
    func scrollToEnd() {

        scroll(NSPoint(x: 0, y: frame.height))
    }
}
