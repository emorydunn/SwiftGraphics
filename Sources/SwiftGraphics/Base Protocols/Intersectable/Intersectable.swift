//
//  Intersectable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 6/29/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Any shape that can calculate points of intersection between itself and a `Line`
public protocol Intersectable: AnyObject, Shape {
    
    
    /// Find any intersection points between the receiver and the specified line
    /// - Parameter line: Line to intersect
    func intersections(with otherShape: Intersectable) -> [Vector]
    
    /// Returns  `Line` segments made of paired points where the specified line intersects
    ///
    /// - Parameter line: The line to test for intersection
    /// - Parameter firstOnly: Return only a `Line` to the closest intersection point
    func lineSegments(_ line: Line, firstOnly: Bool) -> [Line]

    /// Return the intersection of a ray
    ///
    /// From https://math.stackexchange.com/a/311956
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    func rayIntersection(origin: Vector, dir: Vector) -> Vector?
    
    /// Return the intersection of a ray
    ///
    /// From https://math.stackexchange.com/a/311956
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - theta: Direction of the ray
    func rayIntersection(origin: Vector, theta: Radians) -> Vector?

    /// Find intersections for a ray cast from the specified origin.
    ///
    /// Each `Line` represents one segment of the path of the ray.
    ///
    /// - Parameters:
    ///   - angle: Angle, in radians, of the ray.
    ///   - origin: Origin of the ray.
    ///   - objects: Objects to test for intersection.
    /// - Returns: An array of line segments representing intersections and interactions.
    func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line]

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

// MARK: - Default Implementations
extension Intersectable {

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
    
    public func rayIntersection(origin: Vector, theta: Radians) -> Vector? {
        let vector = Vector(angle: theta)
        
        return rayIntersection(origin: origin, dir: vector)
        
    }
    
}

// MARK: - Convenience Methods
extension Intersectable {

    
    /// Find any intersection points between the receiver and the specified line
    /// - Parameters:
    /// - Parameter startPoint: Starting point of the Line
    /// - Parameter endPoint: Ending point of the Line
    /// - Returns: An array of intersection points
    public func lineIntersection(startPoint: Vector, endPoint: Vector) -> [Vector] {
        return intersections(with: Line(startPoint, endPoint))
    }

 
    /// Returns  `Line` segments made of paired points where the specified line intersects
    ///
    /// - Parameter startPoint: Starting point of the Line
    /// - Parameter endPoint: Ending point of the Line
    public func lineSegments(startPoint: Vector, endPoint: Vector, firstOnly: Bool) -> [Line] {
        return lineSegments(Line(startPoint, endPoint), firstOnly: firstOnly)
    }

    /// Find all intersecting points for a ray of a specified angle.
    ///
    /// Each object is tested for intersection and is asked for its own intersections
    /// which may modify the path of the ray.
    ///
    /// - Note: This method provides ray tracing logic and can be called by `intersections(for:origin:objects:)` if
    /// further cusomization is not needed.
    ///
    /// - Parameters:
    ///   - angle: The angle of the ray being cast
    ///   - origin: The origin of the ray being cast
    ///   - objects: Objects to test for intersection, sorted by distance from the origin
    /// - Returns: Lines representing the path taken by the ray
    public func defaultIntersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {

        // Remove self to prevent recursion
        var nonSelfObjects = objects
        nonSelfObjects.removeAll { $0 === self }

        var segments = [Line]()
        var clostestPoint = Double.infinity

        nonSelfObjects.forEach {
            guard let intersection = $0.rayIntersection(origin: origin, theta: angle) else {
                return
            }

            let dist = intersection.dist(origin)
            if dist < clostestPoint {
                clostestPoint = dist
                segments = [Line(origin, intersection)]
            } else {
                return
            }
            
            // Ask the object for its own intersections, unless the object is an Emitter
            guard !($0 is Emitter) else { return }

            // Add the new intersecting segments to the array
            let castSegments = $0.intersections(for: angle,
                                                origin: intersection,
                                                objects: objects)
            segments.append(contentsOf: castSegments)

        }

        return segments

    }

}
