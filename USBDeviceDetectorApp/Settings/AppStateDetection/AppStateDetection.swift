//
//  AppStateDetection.swift
//  USBDeviceDetectorApp
//  
//  Created by Tomohiro Kumagai on 2022/10/18
//  
//

struct AppStateDetection {
    
    static let configurationKey = "Application State Detection"
    
    typealias Terminations = Array<Termination>
    
    var terminations: Terminations
}

extension AppStateDetection : Codable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        terminations = try container.decode(Terminations.self, forKey: .terminations)        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(terminations, forKey: .terminations)
    }
}

private extension AppStateDetection {
    
    enum CodingKeys : String, CodingKey {
        
        case terminations = "Terminations"
    }
}
