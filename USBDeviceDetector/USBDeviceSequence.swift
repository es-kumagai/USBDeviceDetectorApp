//
//  USBDeviceSequence.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import IOKit

struct USBDeviceSequence : Sequence {
    
    private(set) var rawIterator: IOIterator
    
    init(rawIterator: IOIterator) {
        
        self.rawIterator = rawIterator
    }
    
    func makeIterator() -> AnyIterator<USBDevice> {
        
        AnyIterator {
            
            rawIterator.next().map(USBDevice.init)
        }
    }
    
    var devices: [USBDevice] {
        
        Array(self)
    }
}
