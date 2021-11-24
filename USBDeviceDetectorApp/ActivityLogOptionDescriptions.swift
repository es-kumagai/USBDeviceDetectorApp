//
//  ActivityLogOptionDescriptions.swift
//  USBDeviceDetectorApp
//
//  Created by Tomohiro Kumagai on 2021/11/24.
//

@resultBuilder
struct ActivityLogOptionDescriptions {

    static func buildFinalResult(_ component: [String]) -> String {
        
        component.joined(separator: "\n")
    }
    
    static func buildExpression<S: Sequence>(_ expression: S) -> [String] {
        
        expression.map(String.init(describing:))
    }
    
    static func buildExpression<T>(_ expression: T) -> [String] {

        [String(describing: expression)]
    }

    static func buildBlock(_ components: [String]) -> [String] {
        
        components.map { "\t\($0)" }
    }
}
