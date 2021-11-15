//
//  USBDeviceDetectorError.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import IOKit

extension USBDeviceDetector {
    
    enum InstantiationError : Error {
        
        case failedToAddMatchingNotification(IOIterator)
    }
}
