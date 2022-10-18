//
//  Termination.swift
//  USBDeviceDetectorApp
//  
//  Created by Tomohiro Kumagai on 2022/10/18
//  
//

extension AppStateDetection {
    
    struct Termination {
        
        var bundleIdentifier: String
        var force: Bool
    }
}

extension AppStateDetection.Termination : Codable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
        
        switch container.contains(.force) {
            
        case true:
            force = try container.decode(Bool.self, forKey: .force)
            
        case false:
            force = false
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bundleIdentifier, forKey: .bundleIdentifier)
        try container.encode(force, forKey: .force)
    }
}

extension AppStateDetection.Termination : CustomStringConvertible {
    
    var description: String {
        
        switch force {
            
        case true:
            return "\(bundleIdentifier) (force)"

        case false:
            return "\(bundleIdentifier)"
        }
    }
}

private extension AppStateDetection.Termination {
    
    enum CodingKeys : String, CodingKey {
        
        case bundleIdentifier = "Bundle Identifier"
        case force = "Fource"
    }
}
