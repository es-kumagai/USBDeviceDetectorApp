//
//  DeviceMatchingPatternItem.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

extension USBDetection.DeviceMatchingPattern {
    
    enum Item {
        
        case objectID(AudioDevice.ObjectID)
        case namePrefix(String)
        case name(String)
    }
}

extension USBDetection.DeviceMatchingPattern.Item : Codable {

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(String.self, forKey: .value)
        
        switch try container.decode(ItemKey.self, forKey: .key) {
            
        case .objectID:
            guard let value = AudioDevice.ObjectID(value) else {
                throw DecodingError.typeMismatch(AudioDevice.ObjectID.self, .init(codingPath: [CodingKeys.value], debugDescription: "Expected type is \(AudioDevice.ObjectID.self), but actual is \(type(of: value))."))
            }
            self = .objectID(value)
            
        case .namePrefix:
            self = .namePrefix(value)
            
        case .name:
            self = .name(value)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ItemKey(from: self), forKey: .key)

        switch self {
            
        case .objectID(let objectID):
            try container.encode(String(objectID), forKey: .value)

        case .namePrefix(let name), .name(let name):
            try container.encode(name, forKey: .value)
        }
    }
}

private extension USBDetection.DeviceMatchingPattern.Item {

    enum ItemKey : String, Codable {
    
        case objectID = "Object ID"
        case namePrefix = "Name Prefix"
        case name = "Name"
        
        init(from item: USBDetection.DeviceMatchingPattern.Item) {
            
            switch item {
                
            case .objectID:
                self = .objectID
                
            case .namePrefix:
                self = .namePrefix
                
            case .name:
                self = .name
            }
        }
    }
    
    enum CodingKeys : String, CodingKey {
        
        case key = "Key"
        case value = "Value"
    }
}

extension USBDetection.DeviceMatchingPattern {
    
    func matching(to device: AudioDevice) -> Bool {
        
        switch self {
            
        case .matchAll:
            return true
            
        case .notMatchAny:
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

extension USBDetection.DeviceMatchingPattern.Item : CustomStringConvertible {
    
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
