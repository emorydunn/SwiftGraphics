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
}
