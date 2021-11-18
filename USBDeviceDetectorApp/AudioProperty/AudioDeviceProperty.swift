//
//  AudioDeviceProperty.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/18.
//

import CoreAudio

final class AudioDeviceProperty : AudioProperty {
    
    static let mute = AudioDeviceProperty(selector: kAudioDevicePropertyMute)
}
