//
//  RayTracable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 1/15/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import CoreGraphics

/// An object representing a set of straight lines originating from a point.
/// 
/// The `Ray` may be modified by intersecting it with other `Shape`s
public class Ray {
    
    /// The position of the ray
    public var origin: Vector
    
    /// The direction of the ray
    public var direction: Vector

    /// The path the ray has taken
    public var path: [Line] = []
    
    /// Whether or no the ray is terminated
    ///
    /// If this value is true no more tracing will be done
    public var isTerminated: Bool = false
    
    /// How many steps the ray has taken
    ///
    /// The ray is liited to 1000 iterations
    var iterationCount = 0 {
        didSet {
            if iterationCount > 1000 {
                print("Iteration count has crossed threshold")
                terminateRay()
            }
        }
    }
    
    /// Instantiate a new Ray.
    /// - Parameters:
    ///   - origin: The position of the Ray
    ///   - direction: The direction of the Ray
    public init(origin: Vector, direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
    
    /// Instantiate a new Ray.
    /// - Parameters:
    ///   - x: The X position of the Ray.
    ///   - y: The Y position of the Ray.
    ///   - direction: The direction of the Ray, in degrees.
    public convenience init(x: Double, y: Double, direction: Degrees) {
        self.init(
            origin: Vector(x, y),
            direction: Vector(angle: direction.toRadians()))
    }
    
    /// Remove the ray's saved path and reset its iterations
    public func resetPath() {
        path.removeAll()
        iterationCount = 0
    }
    
    /// Stop the receiver from continuing to trace new paths.
    public func terminateRay() {
        isTerminated = true
    }
    
    /// Perform the ray tracing operation.
    /// - Parameter objects: The objects to trace against.
    public func run(objects: [RayTracable]) {
        while isTerminated == false {
            var closestDistance = Double.infinity
            var closestObject: RayTracable?
            var closestPoint: Vector?
            
            // Find the closest intersecting object
            objects.forEach {
                // Find any intersecting points
                guard let intersection = $0.rayIntersection(self) else { return }
//                SwiftGraphicsContext.strokeColor = .init(grey: 0.5)
//                Line(origin, intersection).draw()
//                SwiftGraphicsContext.strokeColor = .black
                
                // Calculate the distance to the intersection
                let dist = intersection.dist(origin)
                
                // If this point is closer than the previous one, replace it
                if dist < closestDistance {
                    closestPoint = intersection
                    closestDistance = dist
                    closestObject = $0
                }
                
            }
            
            // If we have an intersection add its line to the ray
            // and ask the object to modify the ray.
            // Otherwise, terminate the ray
            if let closestObject = closestObject, let closestPoint = closestPoint {
                path.append(Line(origin, closestPoint))
                origin = closestPoint
                closestObject.modifyRay(self)
                
            } else {
                terminateRay()
            }
            iterationCount += 1
            
        }
    }
    
    /// Draw the emitter and ray trace using the specified objects
    /// - Parameters:
    ///   - objects: Objects to test for intersection when casting rays
    public func draw() {
        path.draw()
    }

    /// Draws a representation of the emitter suitable for debugging.
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        //        super.debugDraw(in: context)
        Circle(center: origin, radius: 20).draw()
        
        let dirPoint = direction.copy()
        dirPoint *= 20
        dirPoint += origin
        
        dirPoint.debugDraw(in: context)
    }
    
    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw() {
        // Important: Classes that directly conform to `DrawingContext`
        // must be listed first.
        // Conformance by extension will always succeed, because the
        // method doesn't need to know anything beyond the protocol
        
        switch SwiftGraphicsContext.current {
        case is SVGContext:
            break
        case let context as CGContext:
            debugDraw(in: context)
        default:
            break
        }
        
    }
    
}

extension Array where Element: Ray {
    
    /// A convenience method to draw an array of Rays
    public func draw() {
        self.forEach { $0.draw() }
    }
    
}

/// A shape that can interact with a `Ray`
public protocol RayTracable: Intersectable {
    
    /// Return the intersection of a ray
    /// - Parameters:
    ///   - ray: The `Ray` to intersect
    func rayIntersection(_ ray: Ray) -> Vector?
    
    
    /// Modify the path of a ray.
    ///
    /// The default implementation of this method terminates the `Ray`.
    /// - Parameter ray: The ray to modify
    func modifyRay(_ ray: Ray)
}

public extension RayTracable {
    
    /// Modify the path of a ray.
    ///
    /// The default implementation of this method terminates the `Ray`.
    func modifyRay(_ ray: Ray) {
        ray.terminateRay()
    }
}

public extension RayTracable where Self: Polygon {
    
    /// The interface of the intersection of a ray
    /// - Parameter intersection: The point of intersection
    /// - Returns: A line representing the normal
    func interface(of intersection: Vector) -> Line {
        var entryAngle = angle(ofPoint: intersection)
        if entryAngle < 0 {
            entryAngle = 360.toRadians() + entryAngle
        }
        
        let tangentAngle = entryAngle + 90.toRadians()
        
        return Line(center: intersection, direction: tangentAngle, length: 50)
    }
    
    /// Calculate the angle of deflection using Snell's Law of Reflection
    /// - Parameters:
    ///   - dir: The angle of intersection
    ///   - interface: The interface
    ///   - refraction: The refraction index of the material
    ///   - extIndex: The refraction index of the exterior material
    /// - Returns: A `Vector` rotated by the abgle of reflection
    func deflectionAngle(for dir: Vector, at interface: Line, refraction: Double = 1.46, extIndex: Double = 1.0) -> Vector {

        let dirCopy = dir.copy()
        
        // Determine the angle from the normal
        let thetaInc: Radians = dirCopy.angleBetween(interface.normal())
        
        // Snell's Law of reflection
        let deflection: Radians = asin((extIndex * sin(thetaInc)) / refraction)
        
        dirCopy.rotate(by: deflection)
        
        return dirCopy
        
    }
    
    /// Deflect a ray according to Snell's Law
    /// - Parameter ray: The ray to deflect
    func deflectRay(_ ray: Ray) {
        let interface = self.interface(of: ray.origin)
        ray.direction = deflectionAngle(for: ray.direction, at: interface)
    }
    
    /// Calculate the critical angle of a material
    /// - Parameters:
    ///   - refraction: The refraction index of the material
    ///   - extIndex: The refraction index of the exterior material
    /// - Returns: The critical angle
    func criticalAngle(refraction: Double, extIndex: Double) -> Radians {
        return asin(extIndex / refraction)
    }
    
    /// Modify the path of a ray by deflecting the ray through the object.
    /// - Parameter ray: The ray to modify
    func modifyRay(_ ray: Ray) {
        deflectRay(ray)
    }
}
