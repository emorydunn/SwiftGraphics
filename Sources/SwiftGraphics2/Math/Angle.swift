//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation

public struct Angle {
    
    public static func degrees(_ value: Double) -> Angle {
        Angle(degrees: value)
    }
    
    public static func radians(_ value: Double) -> Angle {
        Angle(radians: value)
    }
    
    public let degrees: Double
    public let radians: Double
    
    init(degrees: Double) {
        self.degrees = degrees
        self.radians = degrees * Double.pi / 180
    }
    
    init(radians: Double) {
        self.degrees = radians * 180 / Double.pi
        self.radians = radians
    }
    
}

public extension Angle {
    static func + (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians + rhs.radians)
    }
}
