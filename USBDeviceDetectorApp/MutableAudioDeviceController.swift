//
//  MutableAudioDeviceController.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/19.
//

import CoreAudio

final class MutableAudioDeviceController {
    
    typealias AudioDeviceIDs = Array<AudioDevice.ObjectID>
    typealias AudioDevices = Array<AudioDevice>

    static var audioObjectController = AudioObjectController.self
    
    var targetDeviceIDs: AudioDeviceIDs
    var deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns
    
    init(targetDeviceIDs: AudioDeviceIDs, deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns = []) {
        
        self.targetDeviceIDs = targetDeviceIDs
        self.deviceMatchingPatterns = deviceMatchingPatterns
    }
    
    convenience init(deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns = []) throws {
    
        try self.init(targetDeviceIDs: Self.currentMutableDevices.map(\.objectID), deviceMatchingPatterns: deviceMatchingPatterns)
    }
    
    convenience init(targetDevicesByName names: Array<String>, deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns = []) throws {

        let targetDevices = try Self.audioObjectController.devices
            .filter(\.canMute)
            .filter { names.contains($0.name) }

        self.init(targetDeviceIDs: targetDevices.map(\.objectID), deviceMatchingPatterns: deviceMatchingPatterns)
    }
    
    static var currentMutableDevices: AudioDevices {
        
        get throws {

            try audioObjectController.devices.filter(\.canMute)
        }
    }

    var currentTargetDevices: AudioDevices {

        get throws {

            try Self.currentMutableDevices
                .filter { deviceMatchingPatterns.matching(to: $0) }
                .filter { targetDeviceIDs.contains($0.objectID) }
        }
    }
    
    func muteAll() throws {
        
        for device in try currentTargetDevices {
            
            device.muted = true
            activityLog("The device named '\(device.name)' has been muted.")
        }
    }
    
    func unmuteAll() throws {
        
        for device in try currentTargetDevices {
            
            device.muted = false
            activityLog("The device named '\(device.name)' has been unmuted.")
        }
    }
}
