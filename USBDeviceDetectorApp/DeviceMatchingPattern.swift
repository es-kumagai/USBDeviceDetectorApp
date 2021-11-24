//
//  DeviceMatchingPattern.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

enum DeviceMatchingPattern {

    case matchAll
    case notMatchAll
    case match(Item)
    case unmatch(Item)
}

extension DeviceMatchingPattern : CustomStringConvertible {

    var description: String {
        
        switch self {
            
        case .matchAll:
            return "Matches all."
            
        case .notMatchAll:
            return "Matches nothing."
            
        case .match(let item):
            return "Matches \(item)."
            
        case .unmatch(let item):
            return "Doesn't match \(item)."
        }
    }
}

extension Sequence where Element == DeviceMatchingPattern {
    
    func matching(to device: AudioDevice) -> Bool {
        
        allSatisfy { $0.matching(to: device) }
    }
}
