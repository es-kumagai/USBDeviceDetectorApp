//
//  AudioDevice.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/17.
//

import CoreAudio

struct AudioDevice {
    
    typealias ObjectID = AudioObjectID
    
    let objectID: ObjectID
    
    var canMute: Bool {
    
        hasProperty(.mute) && isPropertySettable(.mute)
    }
    
    var muted: Bool {
        
        get {
            
            try! get(from: .mute).boolValue
        }
        
        nonmutating set(mute) {
            
            try! set(AudioObjectPropertyValue(mute), to: .mute)
        }
    }
    
    var hasName: Bool {
    
        hasProperty(.name)
    }
    
    var name: String {
        
        try! get(from: .name).stringValue
    }
    
    var hasModelName: Bool {
        
        hasProperty(.modelName)
    }
    
    var modelName: String {
        
        try! get(from: .modelName).stringValue
    }
    
    var hasManufacturer: Bool {
        
        hasProperty(.manufacturer)
    }
    
    var manufacturer: String {
        
        try! get(from: .manufacturer).stringValue
    }
    
    var hasElementName: Bool {
        
        hasProperty(.elementName)
    }
    
    var elementName: String {
        
        try! get(from: .elementName).stringValue
    }
    
    var hasCategoryName: Bool {
        
        hasProperty(.categoryName)
    }
    
    var categoryName: String {
        
        try! get(from: .elementName).stringValue
    }
    
    var hasNumberName: Bool {
        
        hasProperty(.numberName)
    }
    
    var numberName: String {
        
        try! get(from: .elementName).stringValue
    }
    
    var hasIdentify: Bool {
        
        hasProperty(.identify)
    }
    
    var identify: UInt32 {
        
        try! get(from: .identify).number
    }
    
    var hasSerialNumber: Bool {
        
        hasProperty(.serialNumber)
    }
    
    var serialNumber: String {
        
        try! get(from: .serialNumber).stringValue
    }
    
    var hasFirmwareVersion: Bool {
        
        hasProperty(.firmwareVersion)
    }
    
    var firmwareVersion: String {
        
        try! get(from: .firmwareVersion).stringValue
    }
}

extension AudioDevice {
    
    func hasProperty(_ property: AudioDeviceProperty) -> Bool {

        AudioObjectController.propertyExists(property, on: objectID)
    }
    
    func hasProperty(_ property: AudioObjectProperty) -> Bool {

        AudioObjectController.propertyExists(property, on: objectID)
    }
    
    func isPropertySettable(_ property: AudioDeviceProperty) -> Bool {
        
        do {

            return try AudioObjectController.propertySettable(property, on: objectID)
        }
        catch {
            
            return false
        }
    }
    
    func `get`(from property: AudioDeviceProperty) throws -> AudioObjectPropertyValue {
    
        try AudioObjectController.get(property, from: objectID)
    }
    
    func `set`(_ value: AudioObjectPropertyValue, to property: AudioDeviceProperty) throws {
        
        try AudioObjectController.set(value, for: property, to: objectID)
    }

    func `get`(from property: AudioObjectProperty) throws -> AudioObjectPropertyValue {
    
        try AudioObjectController.get(property, from: objectID)
    }
    
    func `set`(_ value: AudioObjectPropertyValue, to property: AudioObjectProperty) throws {
        
        try AudioObjectController.set(value, for: property, to: objectID)
    }
}
