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
    
    private(set) var currentMuteState: Bool = true
    
    init(targetDeviceIDs: AudioDeviceIDs, deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns = []) {
        
        self.targetDeviceIDs = targetDeviceIDs
        self.deviceMatchingPatterns = deviceMatchingPatterns
    }
    
    convenience init(deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns = []) throws {
    
        try self.init(targetDeviceIDs: Self.currentMutableDeviceIDs, deviceMatchingPatterns: deviceMatchingPatterns)
    }
    
    convenience init(targetDevicesByNames names: Array<String>, deviceMatchingPatterns: USBDetection.DeviceMatchingPatterns = []) throws {

        let targetDevices = try Self.devices(byNames: names)

        self.init(targetDeviceIDs: targetDevices.map(\.objectID), deviceMatchingPatterns: deviceMatchingPatterns)
    }
    
    static func devices(byNames names: Array<String>) throws -> AudioDevices {
        
        try audioObjectController.devices
            .filter(\.canMute)
            .filter { names.contains($0.name) }
    }
    
    static func deviceIDs(byNames names: Array<String>) throws -> AudioDeviceIDs {
        
        try devices(byNames: names).map(\.objectID)
    }
    
    static var currentMutableDevices: AudioDevices {
        
        get throws {

            try audioObjectController.devices.filter(\.canMute)
        }
    }
    
    static var currentMutableDeviceIDs: AudioDeviceIDs {
        
        get throws {
            
            try currentMutableDevices.map(\.objectID)
        }
    }

    var currentTargetDevices: AudioDevices {

        get throws {

            try Self.currentMutableDevices
                .filter { deviceMatchingPatterns.matching(to: $0) }
                .filter { targetDeviceIDs.contains($0.objectID) }
        }
    }
        
    func updateTargetDeviceIDsByCurrentMutableDevices() throws {
        
        targetDeviceIDs = try Self.currentMutableDeviceIDs
    }
    
    func updateTargetDeviceIDsByNames(_ names: Array<String>) throws {
        
        targetDeviceIDs = try Self.deviceIDs(byNames: names)
    }
    
    func updateMuteState() throws {
    
        try updateMuteState(currentMuteState)
    }
    
    func updateMuteState(_ mute: Bool) throws {
        
        switch mute {
            
        case true:
            try muteAll()
            
        case false:
            try unmuteAll()
        }
    }
    
    func muteAll() throws {
        
        currentMuteState = true
        
        for device in try currentTargetDevices {
            
            device.muted = true
            activityLog("The device named '\(device.name)' has been muted.")
        }
    }
    
    func unmuteAll() throws {
        
        currentMuteState = false

        for device in try currentTargetDevices {
            
            device.muted = false
            activityLog("The device named '\(device.name)' has been unmuted.")
        }
    }
}
