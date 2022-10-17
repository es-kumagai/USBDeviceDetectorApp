//
//  AppDelegate.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import Cocoa
import USBDeviceDetector
import ApplicationStateDetector

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var configuration = try! Configuration()
    var mutableAudioDeviceController = try! MutableAudioDeviceController()
    var usbDeviceDetector = USBDeviceDetector()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        activityLog("The application did start.")
        
        mutableAudioDeviceController.deviceMatchingPatterns = configuration.usbDetection.deviceMatchingPatterns
        
        configuration.usbDetection.deviceMatchingPatterns = mutableAudioDeviceController.deviceMatchingPatterns

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
            
            switch isTriggerDeviceExists(in: deviceNames) {
                
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
    
    @IBAction func showPreferencesInFinder(_ sender: Any) {
        
        guard let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else {
            
            return
        }

        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let url = URL(fileURLWithPath: libraryPath)
            .appendingPathComponent("Preferences")
            .appendingPathComponent("\(bundleIdentifier).plist")
        
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}

extension AppDelegate {

    func isTriggerDeviceExists<Devices: Sequence>(in deviceNames: Devices) -> Bool where Devices.Element == String {
        
        guard let deviceName = configuration.usbDetection.triggerDeviceName else {
            
            return false
        }
        
        return deviceNames.contains(deviceName)
    }
    
    func isTriggerDeviceExists<Devices: Sequence>(in devices: Devices) -> Bool where Devices.Element == USBDevice {
        
        isTriggerDeviceExists(in: devices.map(\.name))
    }
    
    func isTriggerDeviceExists<Devices: Sequence>(in devices: Devices) -> Bool where Devices.Element == AudioDevice {
        
        isTriggerDeviceExists(in: devices.map(\.name))
    }
}

extension AppDelegate : USBDeviceDetectorDelegate {
    
    func usbDeviceDetector(_ detector: USBDeviceDetector, devicesDidAdd devices: USBDevices) {

        activityLog(label: "Devices have been added") {
            devices.map(\.name)
        }
        
        do {
            
            if isTriggerDeviceExists(in: devices) {
                
                try mutableAudioDeviceController.unmuteAll()
            }
        }
        catch {
            
            print("Failed to mute devices: \(error.localizedDescription)")
        }
    }
    
    func usbDeviceDetector(_ detector: USBDeviceDetector, devicesDidRemove devices: USBDevices) {
        
        activityLog(label: "Devices have been removed") {
            devices.map(\.name)
        }

        do {

            if isTriggerDeviceExists(in: devices) {
                
                try mutableAudioDeviceController.muteAll()
            }
        }
        catch {
            
            activityLog("Failed to unmute devices: \(error.localizedDescription)")
        }
    }
}

extension AppDelegate : ApplicationStateDetectorDelegate {
}
