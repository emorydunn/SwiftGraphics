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
    
    /// A boolean indicating whether the specified point lies within the shape
    func contains(_ point: Vector) -> Bool

    /// Return the intersection point of the specified angle from the center of the shape
    /// - Parameter angle: The angle
    func rayIntersection(_ theta: Radians) -> Vector
}
