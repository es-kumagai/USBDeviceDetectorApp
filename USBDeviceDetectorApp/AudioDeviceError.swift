//
//  AudioDeviceError.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/17.
//

import Foundation

enum AudioObjectOperationError : Error {
    
    case propertyNotExist(AudioProperty)
    case propertyNotSettable(AudioProperty)
    case propertySetFailure(AudioProperty, value: AudioObjectPropertyValue)
    case propertyGetFailure(AudioProperty, status: OSStatus)
    case propertyOperationFailure(AudioProperty, status: OSStatus)
    case propertyValueSizeMismatch(expected: UInt32, actual: UInt32)
}
