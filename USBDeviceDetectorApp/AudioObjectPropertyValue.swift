//
//  AudioObjectPropertyValue.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/17.
//

import Foundation

struct AudioObjectPropertyValue {
    
    private(set) var data: Data
    
    init(data: Data) {
        
        self.data = data
    }
    
    init() {
        
        self.data = Data()
    }
    
    init(number: UInt32) {
        
        let buffer = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        let deallocator = Data.Deallocator.custom { pointer, _ in
            
            pointer.deallocate()
        }
        
        self.init(data: Data(bytesNoCopy: buffer, count: MemoryLayout<UInt32>.size, deallocator: deallocator))
    }
    
    init(maxCapacity capacity: Int = 4, initializer: (_ buffer: UnsafeMutableRawPointer, _ size: inout UInt32) throws -> Void) rethrows {
        
        let buffer = UnsafeMutableRawPointer.allocate(byteCount: capacity, alignment: 1)
        var effectiveSize = UInt32(capacity)
        
        try initializer(buffer, &effectiveSize)
        
        data = Data(bytes: buffer, count: Int(effectiveSize))
    }
    
    var size: UInt32 {
        
        UInt32(data.count)
    }
    
    var isEmpty: Bool {
        
        data.isEmpty
    }
    
    var baseAddress: UnsafeRawPointer {
        
        data.withUnsafeBytes { $0.baseAddress! }
    }
    
    var number: UInt32 {
        
        let expectedSize = MemoryLayout<UInt32>.size
        let actualSize = data.count
        
        guard expectedSize == actualSize else {
            
            fatalError("Expected size is '\(expectedSize)', but actual is '\(actualSize)'.")
        }
        
        return data.withUnsafeBytes { body in
            
            body.load(as: UInt32.self)
        }
    }
}

extension AudioObjectPropertyValue {

    init(_ value: Bool) {
    
        self.init(number: value ? 1 : 0)
    }
    
    var boolValue: Bool {
        
        number != 0
    }
    
    var stringValue: String {

        let string = data.withUnsafeBytes { buffer in
            
            buffer.load(as: NSString.self)
        }
        
        return string as String
    }
    
    func buffer<T>(as type: T.Type) -> UnsafeBufferPointer<T> {
        
        guard !isEmpty else {
            
            return UnsafeBufferPointer<T>(start: nil, count: 0)
        }

        return data.withUnsafeBytes { buffer in

            buffer.bindMemory(to: type)
        }
    }
}
