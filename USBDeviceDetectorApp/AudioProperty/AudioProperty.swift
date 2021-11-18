//
//  AudioProperty.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/18.
//

import CoreAudio

class AudioProperty : RawRepresentable {
    
    let address: UnsafePointer<AudioObjectPropertyAddress>
    
    init(address value: AudioObjectPropertyAddress) {
        
        let buffer = UnsafeMutablePointer<AudioObjectPropertyAddress>.allocate(capacity: 1)
        
        buffer.pointee = value
        address = UnsafePointer(buffer)
    }
    
    convenience init(selector: AudioObjectPropertySelector, scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal, element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain) {
        
        let value = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        
        self.init(address: value)
    }
    
    convenience required init(rawValue: AudioObjectPropertyAddress) {
        
        self.init(address: rawValue)
    }

    deinit {
        
        address.deallocate()
    }
    
    var rawValue: AudioObjectPropertyAddress {
        
        address.pointee
    }
}
