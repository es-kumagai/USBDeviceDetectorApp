//
//  USBDetection.swift
//  USBDeviceDetectorApp
//  
//  Created by Tomohiro Kumagai on 2022/10/17
//  
//

struct USBDetection {
    
    static let configurationKey = "USB Detection"
    
    typealias DeviceMatchingPatterns = Array<DeviceMatchingPattern>
    
    var triggerDeviceName: String?
    var deviceMatchingPatterns: DeviceMatchingPatterns
}

extension USBDetection : Codable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        triggerDeviceName = try container.decode(String?.self, forKey: .triggerDeviceName)
        deviceMatchingPatterns = try container.decode(DeviceMatchingPatterns.self, forKey: .deviceMatchingPatterns)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(triggerDeviceName, forKey: .triggerDeviceName)
        try container.encode(deviceMatchingPatterns, forKey: .deviceMatchingPatterns)
    }
}

private extension USBDetection {
    
    enum CodingKeys : String, CodingKey {
        
        case triggerDeviceName = "Trigger Device Name"
        case deviceMatchingPatterns = "Device Matching Patterns"
    }
}
