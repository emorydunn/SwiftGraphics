//
//  Polygon.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Represens a `Shape` that has an internal area
public protocol Polygon: Intersectable {
    
    func contains(_ point: Vector) -> Bool
    
    func rayIntersection(origin: Vector, theta: Radians) -> Vector?
    
    func rayIntersection(_ theta: Radians) -> Vector
}


extension Polygon {
    
    /// Return an array of points at the specified angular distance apart
    /// - Parameter angle: Angle in degrees
    public func pointsDistributed(every angle: Degrees, starting: Degrees = 0, ending: Degrees = 360) -> [Vector] {
        stride(from: starting, to: ending, by: angle).map { angle in
            rayIntersection(angle.toRadians())
        }
    }
}
