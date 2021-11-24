//
//  AudioController.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/17.
//

import Foundation
import CoreAudio

final class AudioObjectController {
    
    static let systemObject = AudioObjectID(kAudioObjectSystemObject)
    
    static var devices: Array<AudioDevice> {
        
        get throws {

            let value = try get(AudioHardwareProperty.devices, from: systemObject)
            let devices = value.buffer(as: AudioObjectID.self)
            
            return devices.map { AudioDevice(objectID: $0) }
        }
    }
}

internal extension AudioObjectController {

    static func propertyExists(_ property: AudioProperty, on object: AudioObjectID) -> Bool {

        return AudioObjectHasProperty(object, property.address)
    }

    static func propertySettable(_ property: AudioProperty, on object: AudioObjectID) throws -> Bool {
        
        var settable: DarwinBoolean = false
        let status = AudioObjectIsPropertySettable(object, property.address, &settable)
        
        guard case KERN_SUCCESS = status else {
            
            throw AudioObjectOperationError.propertyOperationFailure(property, status: status)
        }

        return settable.boolValue
    }
    
    static func propertyValueSize(of property: AudioProperty, on object: AudioObjectID) throws -> UInt32 {
        
        guard propertyExists(property, on: object) else {
            
            throw AudioObjectOperationError.propertyNotExist(property)
        }
        
        let size = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        
        defer {
            
            size.deallocate()
        }
        
        guard case KERN_SUCCESS = AudioObjectGetPropertyDataSize(object, property.address, 0, nil, size) else {
            
            return 0
        }
        
        return size.pointee
    }

    static func `get`(_ property: AudioProperty, from object: AudioObjectID) throws -> AudioObjectPropertyValue {
    
        var size = try propertyValueSize(of: property, on: object)
        
        guard size > 0 else {
            
            return AudioObjectPropertyValue()
        }
        
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: Int(size), alignment: 1)
        let status = AudioObjectGetPropertyData(object, property.address, 0, nil, &size, buffer)
        
        guard case KERN_SUCCESS = status else {
            
            buffer.deallocate()
            throw AudioObjectOperationError.propertyGetFailure(property, status: status)
        }
        
        let deallocator = Data.Deallocator.custom { pointer, _ in pointer.deallocate() }
        let data = Data(bytesNoCopy: buffer, count: Int(size), deallocator: deallocator)
        
        return AudioObjectPropertyValue(data: data)
    }
    
    static func `set`(_ value: AudioObjectPropertyValue, for property: AudioProperty, to object: AudioObjectID) throws {
        
        guard propertyExists(property, on: object) else {
            
            throw AudioObjectOperationError.propertyNotExist(property)
        }
        
        guard try propertySettable(property, on: object) else {
            
            throw AudioObjectOperationError.propertyNotSettable(property)
        }
        
        try value.withUnsafeBytes { bytes, size in
            
            guard case KERN_SUCCESS = AudioObjectSetPropertyData(object, property.address, 0, nil, size, bytes) else {
                
                throw AudioObjectOperationError.propertySetFailure(property, value: value)
            }
        }
    }

}
