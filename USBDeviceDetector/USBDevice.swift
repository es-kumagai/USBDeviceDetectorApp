//
//  USBDevice.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import Foundation
import IOKit

final class USBDevice : NSObject {
    
    private(set) var object: IOObject
    
    init(object: IOObject) {
        
        self.object = object
    }
    
    var name: String {
        
        let name = UnsafeMutablePointer<io_name_t>.allocate(capacity: 1)
        let buffer = UnsafeMutablePointer<CChar>(OpaquePointer(name))
        
        defer {
            name.deallocate()
        }
        
        guard case KERN_SUCCESS = IORegistryEntryGetName(object.rawObject, buffer) else {
            
            fatalError("Has no name.")
        }

        return String(cString: buffer, encoding: .utf8)!
    }
}
