//
//  IOIterator.swift
//  USBDeviceDetector
//
//  Created by Tomohiro Kumagai on 2021/11/14.
//

import IOKit

final class IOIterator {
    
    var type: String
    var rawIterator: UnsafeMutablePointer<io_iterator_t>?
    
    init(type: String, retainedIterator iterator: io_iterator_t) {
        
        self.type = type
        self.rawIterator = .allocate(capacity: 1)
        
        rawIterator?.pointee = iterator
    }
    
    convenience init(type: String) {
    
        self.init(type: type, iterator: IO_OBJECT_NULL)
    }
    
    convenience init(type: String, iterator: io_iterator_t) {
        
        self.init(type: type, retainedIterator: iterator)
        IOObjectRetain(iterator)
    }
    
    deinit {

        invalidate()
    }
    
    var isValid: Bool {
        
        guard let iterator = rawIterator else {
        
            return false
        }
        
        return IOIteratorIsValid(iterator.pointee) != 0
    }
    
    func invalidate() {
        
        guard isValid else {
        
            return
        }

        defer {
        
            IOObjectRelease(rawIterator!.pointee)
            rawIterator = nil
        }
                
        while let object = next() {

            object.invalidate()
        }
    }
}

extension IOIterator : IteratorProtocol {
    
    func next() -> IOObject? {

        guard isValid else {
            
            return nil
        }
        
        guard let object = IOObject(retainedObject: IOIteratorNext(rawIterator!.pointee)) else {
            
            return nil
        }
            
        return object
    }
}

extension IOIterator : Sequence {
    
}
