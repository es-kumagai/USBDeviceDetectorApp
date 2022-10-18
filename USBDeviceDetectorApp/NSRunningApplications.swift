//
//  NSRunningApplications.swift
//  USBDeviceDetectorApp
//  
//  Created by Tomohiro Kumagai on 2022/10/18
//  
//

import AppKit

typealias NSRunningApplications = Array<NSRunningApplication>

extension NSRunningApplication {

    static let terminationCheckIntervalInNanoseconds: UInt64 = 100_000_000
    
    func waitForFinishingTermination(timeout: DispatchTime = .distantFuture) throws {
    
        let semaphore = DispatchSemaphore(value: 0)
        let processIdentifier = processIdentifier
        
        Task.detached {
            
            defer {
                semaphore.signal()
            }

            guard let runningApplication = NSRunningApplication(processIdentifier: processIdentifier) else {
                
                return
            }
            
            while !runningApplication.isTerminated {
                
                try? await Task.sleep(nanoseconds: Self.terminationCheckIntervalInNanoseconds)
            }
        }
        
        guard case .timedOut = semaphore.wait(timeout: timeout) else {
            
            throw CancellationError()
        }
    }
    
    func terminatewithWaitingUntilDone(timeout: DispatchTime = .distantFuture) throws {
        
        terminate()
        try waitForFinishingTermination(timeout: timeout)
    }
    
    func forceTerminateWithWaitingUntilDone(timeout: DispatchTime = .distantFuture) throws {
        
        forceTerminate()
        try waitForFinishingTermination(timeout: timeout)
    }
}

extension NSRunningApplications {

    static let terminationCheckIntervalInNanoseconds: UInt64 = 100_000_000

    init(withBundleIdentifier bundleIdentifier: String) {
        
        self = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
    }
    
    init<ProcessIdentifiers: Sequence>(processIdentifiers: ProcessIdentifiers) where ProcessIdentifiers.Element == pid_t {
        
        self = processIdentifiers.compactMap(NSRunningApplication.init(processIdentifier:))
    }
}

extension Sequence where Element == NSRunningApplication {
    
    var isAllTerminated: Bool {
        
        allSatisfy(\.isTerminated)
    }
    
    func waitForFinishingAllTermination(timeout: DispatchTime = .distantFuture) throws {
        
        let semaphore = DispatchSemaphore(value: 0)
        let processIdentifiers = map(\.processIdentifier)
        
        Task.detached {
            
            defer {
                semaphore.signal()
            }
            
            while !NSRunningApplications(processIdentifiers: processIdentifiers).isAllTerminated {
                
                try? await Task.sleep(nanoseconds: NSRunningApplications.terminationCheckIntervalInNanoseconds)
            }
        }
        
        guard case .timedOut = semaphore.wait(timeout: timeout) else {
            
            throw CancellationError()
        }
    }
    
    func terminate() {
        
        forEach { $0.terminate() }
    }
    
    func forceTerminate() {
        
        forEach { $0.forceTerminate() }
    }
    
    func terminateWithWaitingUntilDone(timeout: DispatchTime = .distantFuture) throws {
        
        terminate()
        try waitForFinishingAllTermination(timeout: timeout)
    }
    
    func forceTerminateWithWaitingUntilDone(timeout: DispatchTime = .distantFuture) throws {
        
        forceTerminate()
        try waitForFinishingAllTermination(timeout: timeout)
    }
}
