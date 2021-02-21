//
//  Angles.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An number representing degrees
public typealias Degrees = Double

/// An number representing radians
public typealias Radians = Double

extension Degrees {

    /// Convert an angle to radians
    public func toRadians() -> Radians {
        return self * Double.pi / 180
    }
}

extension Radians {

    /// Convert an angle to degrees
    public func toDegrees() -> Degrees {
        return self * 180 / Double.pi
    }
    
    /// Pi, multiplied by two.
    public static let twoPi = Double.pi * 2
    
    /// Pi, divided by two.
    public static let halfPi = Double.pi / 2
    
    
    /// A full circle
    public static let fullCircle = Radians.twoPi
    
    /// A half circle
    public static let halfCircle = Radians.pi
    
    /// A quarter circle
    public static let quarterCircle = Radians.halfPi
}
