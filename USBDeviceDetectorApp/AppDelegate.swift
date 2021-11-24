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

    var mutableAudioDeviceController = try! MutableAudioDeviceController()
    var usbDeviceDetector = USBDeviceDetector()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        activityLog("The application did start.")
        
        mutableAudioDeviceController.deviceMatchingPatterns = [
            
            .unmatch(.namePrefix("Soundflower")),
            .unmatch(.name("AirPods Max #1")),
        ]
        
        usbDeviceDetector.delegate = self
        
        activityLog(label: "Matching patterns") {
            mutableAudioDeviceController.deviceMatchingPatterns
        }
            
        do {

            let devices = try mutableAudioDeviceController.currentTargetDevices
            let deviceNames = devices.map(\.name)
            
            activityLog(label: "Current target devices") {
                deviceNames
            }
            
            switch deviceNames.contains(Self.triggerDeviceName) {
                
            case true:
                try mutableAudioDeviceController.unmuteAll()
                
            case false:
                try mutableAudioDeviceController.muteAll()
            }
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {

        usbDeviceDetector.delegate = nil
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

extension AppDelegate : USBDeviceDetectorDelegate {
    
    static let triggerDeviceName = "Microsoft® 2.4GHz Transceiver v9.0"
    
    func usbDeviceDetector(_ detector: USBDeviceDetector, devicesDidAdd devices: [USBDevice]) {

        activityLog(label: "Devices have been added") {
            devices.map(\.name)
        }
        
        do {
            
            if devices.contains(name: Self.triggerDeviceName) {
                
                try mutableAudioDeviceController.unmuteAll()
            }
        }
        catch {
            
            print("Failed to mute devices: \(error.localizedDescription)")
        }
    }
    
    func usbDeviceDetector(_ detector: USBDeviceDetector, devicesDidRemove devices: [USBDevice]) {
        
        activityLog(label: "Devices have been removed") {
            devices.map(\.name)
        }

        do {

            if devices.contains(name: Self.triggerDeviceName) {
                
                try mutableAudioDeviceController.muteAll()
            }
        }
        catch {
            
            activityLog("Failed to unmute devices: \(error.localizedDescription)")
        }
    }
}
