//
//  Configuration.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2022/03/22.
//

import Foundation
import USBDeviceDetector

struct Configuration {
    
    typealias DeviceMatchingPatterns = Array<DeviceMatchingPattern>
    
    var triggerDeviceName: String?
    var deviceMatchingPatterns: DeviceMatchingPatterns
    
    init() throws {
        
        triggerDeviceName = Self.triggerDeviceNameInUserDefaults
        deviceMatchingPatterns = Self.deviceMatchingPatternsInUserDefaults
    }
}

extension Configuration {

    enum ConfigurationError : Error {
        
        case folderPathIsNotDirectory
        case failedToCreateDirectory(Error)
    }
}

extension Configuration {
    
    static let userDefaults = UserDefaults.standard
    static let triggerDeviceNameKey = "Trigger Device Name"
    static let deviceMatchingPatternsKey = "Device Matching Patterns"

    static var triggerDeviceNameInUserDefaults: String? {
        
        get {
            
            userDefaults.string(forKey: triggerDeviceNameKey)
        }
        
        set (deviceName) {
            
            userDefaults.set(deviceName, forKey: triggerDeviceNameKey)
        }
    }
    
    static var deviceMatchingPatternsInUserDefaults: DeviceMatchingPatterns {
        
        get {
            
            guard let dictionary = userDefaults.object(forKey: deviceMatchingPatternsKey) else {
                
                return []
            }

            let decoder = PropertyListDecoder()
            let data = try! PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            
            return try! decoder.decode(DeviceMatchingPatterns.self, from:
data)
        }
        
        set (patterns) {
            
            let encoder = PropertyListEncoder()
            
            let data = try! encoder.encode(patterns)
            let dictionary = try! PropertyListSerialization.propertyList(from: data, format: nil)

            userDefaults.set(dictionary, forKey: deviceMatchingPatternsKey)
        }
    }
    
    func save() throws {
        
        Self.triggerDeviceNameInUserDefaults = triggerDeviceName
        Self.deviceMatchingPatternsInUserDefaults = deviceMatchingPatterns
    }    
}
