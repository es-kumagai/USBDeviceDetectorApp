//
//  DeviceMatchingPatternItem.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

extension DeviceMatchingPattern {
    
    enum Item {
        
        case objectID(AudioDevice.ObjectID)
        case namePrefix(String)
        case name(String)
    }
}

extension DeviceMatchingPattern {
    
    func matching(to device: AudioDevice) -> Bool {
        
        switch self {
            
        case .matchAll:
            return true
            
        case .notMatchAll:
            return false
            
        case .match(.objectID(let objectID)):
            return device.objectID == objectID

        case .match(.namePrefix(let prefix)):
            return device.name.hasPrefix(prefix)

        case .match(.name(let name)):
            return device.name == name
            
        case .unmatch(.objectID(let objectID)):
            return device.objectID != objectID

        case .unmatch(.namePrefix(let prefix)):
            return !device.name.hasPrefix(prefix)

        case .unmatch(.name(let name)):
            return device.name != name
        }
    }
}

extension DeviceMatchingPattern.Item : CustomStringConvertible {
    
    var description: String {
        
        switch self {
            
        case .name(let name):
            return "the device named '\(name)'"
            
        case .namePrefix(let prefix):
            return "devices with a name begins with '\(prefix)'"
            
        case .objectID(let id):
            return "the object ID is \(id)"
        }
    }
}
