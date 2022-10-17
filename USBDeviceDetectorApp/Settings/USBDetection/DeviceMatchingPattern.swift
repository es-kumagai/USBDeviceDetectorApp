//
//  DeviceMatchingPattern.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

extension USBDetection {
    
    enum DeviceMatchingPattern {
        
        case matchAll
        case notMatchAny
        case match(Item)
        case unmatch(Item)
    }
}

extension USBDetection.DeviceMatchingPattern : Codable {

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let method = try container.decode(MethodKey.self, forKey: .method)
        let item = try container.decode(Item?.self, forKey: .item)
        
        switch (method, item) {
            
        case (.matchAll, nil):
            self = .matchAll
            
        case (.notMatchAny, nil):
            self = .notMatchAny
            
        case (.notMatchAny, _?), (.matchAll, _?):
            throw DecodingError.dataCorruptedError(forKey: .item, in: container, debugDescription: "An item is associated with the method.")
            
        case (.match, let item?):
            self = .match(item)
            
        case (.unmatch, let item?):
            self = .unmatch(item)
            
        case (.match, nil), (.unmatch, nil):
            throw DecodingError.dataCorruptedError(forKey: .item, in: container, debugDescription: "No item is associated with the method.")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(MethodKey(from: self), forKey: .method)
        
        switch self {
            
        case .matchAll, .notMatchAny:
            break

        case .match(let item), .unmatch(let item):
            try container.encode(item as Optional, forKey: .item)
        }
    }
}

private extension USBDetection.DeviceMatchingPattern {

    enum CodingKeys : String, CodingKey {
        
        case method = "Method"
        case item = "Item"
    }
    
    enum MethodKey : String, Codable {
    
        case matchAll = "Match All"
        case notMatchAny = "Not Match Any"
        case match = "Match"
        case unmatch = "Unmatch"
        
        init(from item: USBDetection.DeviceMatchingPattern) {
            
            switch item {
                
            case .matchAll:
                self = .matchAll
                
            case .notMatchAny:
                self = .notMatchAny
                
            case .match:
                self = .match
                
            case .unmatch:
                self = .unmatch
            }
        }
    }
}

extension USBDetection.DeviceMatchingPattern : CustomStringConvertible {

    var description: String {
        
        switch self {
            
        case .matchAll:
            return "Matches all."
            
        case .notMatchAny:
            return "Matches nothing."
            
        case .match(let item):
            return "Matches \(item)."
            
        case .unmatch(let item):
            return "Doesn't match \(item)."
        }
    }
}

extension Sequence where Element == USBDetection.DeviceMatchingPattern {
    
    func matching(to device: AudioDevice) -> Bool {
        
        allSatisfy { $0.matching(to: device) }
    }
}
