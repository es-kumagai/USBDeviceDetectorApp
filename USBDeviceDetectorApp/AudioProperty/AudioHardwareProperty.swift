//
//  AudioHardwareProperty.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/18.
//

import CoreAudio

final class AudioHardwareProperty : AudioProperty {
    
    static let devices = AudioHardwareProperty(selector: kAudioHardwarePropertyDevices)
}
