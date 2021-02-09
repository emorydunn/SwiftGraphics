//
//  Intersectable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 6/29/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Any shape that can calculate points of intersection between itself and a `Line` or `Vector`
public protocol Intersectable: AnyObject, Shape {
    
    
    /// Find any intersection points between the receiver and the specified line
    /// - Parameter line: Line to intersect
    func intersections(with otherShape: Intersectable) -> [Vector]
    
    /// Returns  `Line` segments made of paired points where the specified line intersects
    ///
    /// - Parameter line: The line to test for intersection
    /// - Parameter firstOnly: Return only a `Line` to the closest intersection point
    @available(*, deprecated)
    func lineSegments(_ line: Line, firstOnly: Bool) -> [Line]

}

extension Intersectable where Self: Polygon {

    /// Return an array of points at the specified angular distance apart
    /// - Parameter angle: Angle in degrees
    public func pointsDistributed(every angle: Degrees, starting: Degrees = 0, ending: Degrees = 360) -> [Vector] {
        stride(from: starting, to: ending, by: angle).map { angle in
            point(at: angle.toRadians())
        }
    }
}

// MARK: - Default Implementations
extension Intersectable {

    @available(*, deprecated)
    public func lineSegments(_ line: Line, firstOnly: Bool) -> [Line] {
        var intersections = self.intersections(with: line)
        
        guard intersections.count > 0 else {
            return []
        }
        intersections.insert(line.start, at: 0)
        intersections.append(line.end)
        
        var segments = intersections
            .sortedByDistance(from: line.start)
            .paired()
            .map { Line($0.0, $0.1) }
        
        if firstOnly {
            segments.removeLast(segments.count - 1)
        }
        
        return segments
    }
    
//    @available(*, deprecated, message: "Use RayTracable")
//    public func rayIntersection(origin: Vector, theta: Radians) -> Vector? {
//        let vector = Vector(angle: theta)
//
//        return rayIntersection(origin: origin, dir: vector)
//
//    }
    
}

// MARK: - Convenience Methods
extension Intersectable {

    
    /// Find any intersection points between the receiver and the specified line
    /// - Parameters:
    /// - Parameter startPoint: Starting point of the Line
    /// - Parameter endPoint: Ending point of the Line
    /// - Returns: An array of intersection points
    @available(*, deprecated)
    public func lineIntersection(startPoint: Vector, endPoint: Vector) -> [Vector] {
        return intersections(with: Line(startPoint, endPoint))
    }

 
    /// Returns  `Line` segments made of paired points where the specified line intersects
    ///
    /// - Parameter startPoint: Starting point of the Line
    /// - Parameter endPoint: Ending point of the Line
    @available(*, deprecated)
    public func lineSegments(startPoint: Vector, endPoint: Vector, firstOnly: Bool) -> [Line] {
        return lineSegments(Line(startPoint, endPoint), firstOnly: firstOnly)
    }

}
