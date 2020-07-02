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
   
    func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line]
 
}

extension RayTracer {
    
    
    /// Find all intersecting points for a ray of a specified angle.
    ///
    /// - Note: This method calls `defaultIntersections(for:origin:objects:)` and only
    /// needs to be customized by `RayTracers` that want to modify the path of the ray.
    ///
    /// - Parameters:
    ///   - angle: The angle of the ray being cast
    ///   - origin: The origin of the ray being cast
    ///   - objects: Objects to test for intersection, sorted by distance from the origin
    /// - Returns: Lines representing the path taken by the ray
    public func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return defaultIntersections(for: angle, origin: origin, objects: objects)
    }
    
    /// Find all intersecting points for a ray of a specified angle.
    ///
    /// Each object is tested for intersection, and if the object is a `RayTracer` that tracer is asked for its own intersections which may modify the path of the ray.
    ///
    /// - Note: This method provides ray tracing logic and is called by the default implementation of  `intersections(for:origin:objects:)`.
    ///
    /// - Parameters:
    ///   - angle: The angle of the ray being cast
    ///   - origin: The origin of the ray being cast
    ///   - objects: Objects to test for intersection, sorted by distance from the origin
    /// - Returns: Lines representing the path taken by the ray
    func defaultIntersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        
        // Remove self to prevent recursion
        var nonSelfObjects = objects
        nonSelfObjects.removeAll { ($0 as? RayTracer) === self }
        
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
            
            // Test is the object is a RayTracer, to continue adding lines
            guard let tracer = $0 as? RayTracer, ($0 as? Emitter) == nil else {
                return
            }
            
            // Add the new intersecting segments to the array
            let castSegments = tracer.intersections(for: angle,
                                                    origin: intersection,
                                                    objects: objects)
            segments.append(contentsOf: castSegments)
            
            
        }
        
        return segments
        
    }
    
}
