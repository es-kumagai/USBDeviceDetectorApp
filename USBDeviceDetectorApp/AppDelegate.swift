//
//  AppDelegate.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import Cocoa
import USBDeviceDetector

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var usbDeviceDetector = USBDeviceDetector()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        usbDeviceDetector.delegate = self
    }

    func applicationWillTerminate(_ aNotification: Notification) {

        usbDeviceDetector.delegate = nil
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

extension AppDelegate : USBDeviceDetectorDelegate {
    
    func usbDeviceDetector(_ detector: USBDeviceDetector, devicesDidAdd devices: [USBDevice]) {
     
        print("Added", devices.map(\.name))
    }
    
    func usbDeviceDetector(_ detector: USBDeviceDetector, devicesDidRemove devices: [USBDevice]) {
        
        print("Removed", devices.map(\.name))
    }
}
