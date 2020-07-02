//
//  RayCaster.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An object that can calculate intersections beetween a ray and other objects
public protocol RayTracer: AnyObject, Shape {
    
    func intersections(for angle: Radians, origin: Vector, bb: BoundingBox, objects: [Intersectable]) -> [Line]
    
    func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line]
    
//    var passStyle: Bool { get set }

}

extension RayTracer {
    
    /// Find all intersecting points for a ray of a specified angle.
    ///
    /// If no object is hit by a ray no point is returned. 
    ///
    /// The result always includes the intersection on the bounding box.
    /// - Parameters:
    ///   - angle: The angle of the ray being cast
    ///   - origin: The origin of the ray being cast
    ///   - bb: The `BoundingBox` to terminate the ray on
    ///   - objects: Objects to test for intersection, sorted by distance from the origin
    func defaultIntersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        
        let intersections: [Vector] = objects.compactMap {
            return $0.rayIntersection(origin: origin, theta: angle)
        }
        let sorted = intersections.sortedByDistance(from: origin)
        guard !sorted.isEmpty else { return [] }
        
        return [Line(origin, sorted[0])]
        
    }
    
    public func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return defaultIntersections(for: angle, origin: origin, objects: objects)
    }
    
    /// Find all intersecting points for a ray of a specified angle, terminating on a `BoundingBox`
    ///
    /// The result always includes the intersection on the bounding box.
    /// - Parameters:
    ///   - angle: The angle of the ray being cast
    ///   - origin: The origin of the ray being cast
    ///   - bb: The `BoundingBox` to terminate the ray on
    ///   - objects: Objects to test for intersection, sorted by distance from the origin
    public func defaultIntersections(for angle: Radians, origin: Vector, bb: BoundingBox, objects: [Intersectable]) -> [Line] {
        
        // Calculate point to end of BB
        guard let endPoint = bb.rayIntersection(origin: origin, theta: angle) else {
            return []
        }
        
        let rayLine = Line(origin, endPoint)
        
        var shortestLine = rayLine
        var segments = [rayLine]
        
        objects.forEach { object in
            // Test for object intersections
            let objSegments = object.lineSegments(rayLine, firstOnly: true)
            guard objSegments.count > 0 else { return }
            
            // Check if the new object is closer than the previous one
            guard objSegments[0].length < shortestLine.length else {
                return
            }
            
            // Use this objects lines
            shortestLine = objSegments[0]
            segments = objSegments // [objSegments[0]] //objSegments.removeLast(segments.count - 1)
            
            // Test is the object is a RayTracer, to continue adding lines
            guard let tracer = object as? RayTracer, (object as? Emitter) == nil else {
                return
            }
            
            // Make a copy of the objects
            var rayCasters = objects
            // Remove self to prevent recursion and replace with a copy of the core circle
            rayCasters.removeAll { ($0 as? RayTracer) === self }
            
            // Add the new intersecting segments to the array
            let castSegments = tracer.intersections(for: angle, origin: shortestLine.end, bb: bb, objects: rayCasters)
            segments.append(contentsOf: castSegments)
            
            
        }
        
        return segments
    }
    
    /// Find all intersecting points for a ray of a specified angle, terminating on a `BoundingBox`
    ///
    /// The result always includes the intersection on the bounding box.
    ///
    /// - Important: This method simply calls `defaultIntersections(for:origin:bb:objects:)`, which has a default set of ray tracing logic.
    /// Your `RayTracer` can modify a call to this method and call the default implementation, if needed. 
    ///
    ///
    /// - Parameters:
    ///   - angle: The angle of the ray being cast
    ///   - origin: The origin of the ray being cast
    ///   - bb: The `BoundingBox` to terminate the ray on
    ///   - objects: Objects to test for intersection, sorted by distance from the origin
    public func intersections(for angle: Radians, origin: Vector, bb: BoundingBox, objects: [Intersectable]) -> [Line] {
        return defaultIntersections(for: angle, origin: origin, bb: bb, objects: objects)

    }
}
