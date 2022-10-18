//
//  Configuration.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2022/03/22.
//

import Foundation
import USBDeviceDetector

struct Configuration {
    
    var usbDetection: USBDetection
    var appStateDetection: AppStateDetection
    
    init() throws {
        
        usbDetection = Self.usbDetectionInUserDefaults
        appStateDetection = Self.appStateDetectionInUserDefaults
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
        
    static var usbDetectionInUserDefaults: USBDetection {
        
        get {
            
            guard let dictionary = userDefaults.object(forKey: USBDetection.configurationKey) else {
                
                return USBDetection(triggerDeviceName: nil, deviceMatchingPatterns: [])
            }

            let decoder = PropertyListDecoder()
            let data = try! PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            
            return try! decoder.decode(USBDetection.self, from:
data)
        }
        
        set (patterns) {
            
            let encoder = PropertyListEncoder()
            
            let data = try! encoder.encode(patterns)
            let dictionary = try! PropertyListSerialization.propertyList(from: data, format: nil)

            userDefaults.set(dictionary, forKey: USBDetection.configurationKey)
        }
    }
    
    static var appStateDetectionInUserDefaults: AppStateDetection {
        
        get {
            
            guard let dictionary = userDefaults.object(forKey: AppStateDetection.configurationKey) else {
                
                return AppStateDetection(terminations: [])
            }

            let decoder = PropertyListDecoder()
            let data = try! PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            
            return try! decoder.decode(AppStateDetection.self, from:
data)
        }
        
        set (patterns) {
            
            let encoder = PropertyListEncoder()
            
            let data = try! encoder.encode(patterns)
            let dictionary = try! PropertyListSerialization.propertyList(from: data, format: nil)

            userDefaults.set(dictionary, forKey: AppStateDetection.configurationKey)
        }
    }
    
    func save() throws {
        
        Self.usbDetectionInUserDefaults = usbDetection
    }
}
