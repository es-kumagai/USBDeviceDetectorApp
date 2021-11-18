//
//  AudioDeviceProperty.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/17.
//

import CoreAudio

final class AudioObjectProperty : AudioProperty {

    /// An AudioClassID that identifies the class from which the class of the
    /// AudioObject is derived. This value must always be one of the standard classes.
    static let baseClass = AudioObjectProperty(selector: kAudioObjectPropertyBaseClass)
    
    /// An AudioClassID that identifies the class of the AudioObject.
    static let `class` = AudioObjectProperty(selector: kAudioObjectPropertyClass)

    /// An AudioObjectID that identifies the the AudioObject that owns the given
    /// AudioObject. Note that all AudioObjects are owned by some other AudioObject.
    /// The only exception is the AudioSystemObject,
    /// for which the value of this property is kAudioObjectUnknown.
    static let owner = AudioObjectProperty(selector: kAudioObjectPropertyOwner)

    /// A CFString that contains the human readable name of the object.
    /// The caller is responsible for releasing the returned CFObject.
    static let name = AudioObjectProperty(selector: kAudioObjectPropertyName)

    /// A CFString that contains the human readable model name of the object.
    /// The model name differs from kAudioObjectPropertyName in that two objects of the
    /// same model will have the same value for this property but may have different
    /// values for kAudioObjectPropertyName.
    static let modelName = AudioObjectProperty(selector: kAudioObjectPropertyModelName)

    /// A CFString that contains the human readable name of the manufacturer of the
    /// hardware the AudioObject is a part of. The caller is responsible for
    /// releasing the returned CFObject.
    static let manufacturer = AudioObjectProperty(selector: kAudioObjectPropertyManufacturer)

    /// A CFString that contains a human readable name for the given element in the
    /// given scope. The caller is responsible for releasing the returned CFObject.
    static let elementName = AudioObjectProperty(selector: kAudioObjectPropertyElementName)

    /// A CFString that contains a human readable name for the category of the given
    /// element in the given scope. The caller is responsible for releasing the returned CFObject.
    static let categoryName = AudioObjectProperty(selector: kAudioObjectPropertyElementCategoryName)

    /// A CFString that contains a human readable name for the number of the given
    /// element in the given scope. The caller is responsible for releasing the
    /// returned CFObject.
    static let numberName = AudioObjectProperty(selector: kAudioObjectPropertyElementNumberName)

    /// An array of AudioObjectIDs that represent all the AudioObjects owned by the
    /// given object. The qualifier is an array of AudioClassIDs. If it is
    /// non-empty, the returned array of AudioObjectIDs will only refer to objects
    /// whose class is in the qualifier array or whose is a subclass of one in the
    /// qualifier array.
    static let ownedObjects = AudioObjectProperty(selector: kAudioObjectPropertyOwnedObjects)

    /// A UInt32 where a value of one indicates that the object's hardware is
    /// drawing attention to itself, typically by flashing or lighting up its front
    /// panel display. A value of 0 indicates that this function is turned off. This
    /// makes it easy for a user to associate the physical hardware with its
    /// representation in an application. Typically, this property is only supported
    /// by AudioDevices and AudioBoxes.
    static let identify = AudioObjectProperty(selector: kAudioObjectPropertyIdentify)

    /// A CFString that contains the human readable serial number for the object.
    /// This property will typically be implemented by AudioBox and AudioDevice
    /// objects. Note that the serial number is not defined to be unique in the same
    /// way that an AudioBox's or AudioDevice's UID property are defined. This is
    /// purely an informational value. The caller is responsible for releasing the
    /// returned CFObject.
    static let serialNumber = AudioObjectProperty(selector: kAudioObjectPropertySerialNumber)

    /// A CFString that contains the human readable firmware version for the object.
    /// This property will typically be implemented by AudioBox and AudioDevice
    /// objects. Note that this is purely an informational value. The caller is
    /// responsible for releasing the returned CFObject.
    static let firmwareVersion = AudioObjectProperty(selector: kAudioObjectPropertyFirmwareVersion)
}
