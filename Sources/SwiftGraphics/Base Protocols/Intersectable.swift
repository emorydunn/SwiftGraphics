//
//  Intersectable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 6/29/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation


/// Any shape that can calculate points of intersection between itself and a `Line`
public protocol Intersectable: Shape {
    func lineIntersection(_ line: Line) -> [Vector]
    
    func lineSegments(_ line: Line, firstOnly: Bool) -> [Line]
    
    func rayIntersection(origin: Vector, dir: Vector) -> Vector?
    func rayIntersection(origin: Vector, theta: Radians) -> Vector?
    
}

extension Intersectable where Self: Polygon {
    
    /// Return an array of points at the specified angular distance apart
    /// - Parameter angle: Angle in degrees
    public func pointsDistributed(every angle: Degrees, starting: Degrees = 0, ending: Degrees = 360) -> [Vector] {
        stride(from: starting, to: ending, by: angle).map { angle in
            rayIntersection(angle.toRadians())
        }
    }
}

extension Intersectable {
    
    public func rayIntersection(origin: Vector, theta: Radians) -> Vector? {
        let e = Vector(angle: theta)
        
        return rayIntersection(origin: origin, dir: e)

    }
    
    
    public func lineIntersection(startPoint: Vector, endPoint: Vector) -> [Vector] {
        return lineIntersection(Line(startPoint, endPoint))
    }
    
    /// Returns  `Line` segments made of paired points where the specified line intersects
    ///
    /// - Parameter line: The line to test for intersection
    /// - Parameter firstOnly: Return only a `Line` to the closest intersection point
    public func lineSegments(_ line: Line, firstOnly: Bool) -> [Line] {
        var intersections = self.lineIntersection(line)

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
    
    public func lineSegments(startPoint: Vector, endPoint: Vector, firstOnly: Bool) -> [Line] {
        return lineSegments(Line(startPoint, endPoint), firstOnly: firstOnly)
    }
    
}
