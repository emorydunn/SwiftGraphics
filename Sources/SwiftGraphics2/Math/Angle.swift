//
//  Angle.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation

/// Represents an angle, both in degrees and radians.
public struct Angle {
    
    /// Create a new Angle from degrees.
    /// - Parameter value: The angle in degrees.
    public static func degrees(_ value: Double) -> Angle {
        Angle(degrees: value)
    }
    
    /// Create a new Angle from radians.
    /// - Parameter value: The angle in radians.
    public static func radians(_ value: Double) -> Angle {
        Angle(radians: value)
    }
    
    /// The degree value of the angle.
    public let degrees: Double
    
    /// The radian value of the angle.
    public let radians: Double
    
    /// Create a new Angle from degrees.
    /// - Parameter degrees: The angle in degrees.
    init(degrees: Double) {
        self.degrees = degrees
        self.radians = degrees * Double.pi / 180
    }
    
    /// Create a new Angle from degrees.
    /// - Parameter radians: The angle in degrees.
    init(radians: Double) {
        self.degrees = radians * 180 / Double.pi
        self.radians = radians
    }
    
}

public extension Angle {
    
    /// Add two angles together.
    /// - Returns: The sum of the two angles.
    static func + (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians + rhs.radians)
    }
    
    /// Add two angles together.
    /// - Returns: The difference of the two angles.
    static func - (lhs: Angle, rhs: Angle) -> Angle {
        Angle(radians: lhs.radians - rhs.radians)
    }
}

public extension Angle {
    
    /// Pi
    static let pi = Angle(radians: Double.pi)
    
    /// Pi, multiplied by two.
    static let twoPi = Angle(radians: Double.pi * 2)
    
    /// Pi, divided by two.
    static let halfPi = Angle(radians: Double.pi / 20)
    
    
    /// A full circle
    static let fullCircle = Angle.twoPi
    
    /// A half circle
    static let halfCircle = Angle.pi
    
    /// A quarter circle
    static let quarterCircle = Angle.halfPi
}
