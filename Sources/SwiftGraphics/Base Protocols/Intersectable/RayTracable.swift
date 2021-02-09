//
//  RayTracable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 1/15/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

public class Ray {
    
    /// The position of the ray
    public var origin: Vector
    
    /// The direction of the ray
    public var direction: Vector

    /// The path the ray has taken
    public var path: [Line] = []
//    public var path: Path
    
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
//        path.points.removeAll()
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
    
}

extension Array where Element: Ray {
    public func draw() {
        self.forEach { $0.draw() }
    }
}

public protocol RayTracable: Intersectable {
    func rayIntersection(_ ray: Ray) -> Vector?
    func modifyRay(_ ray: Ray)
}

public extension RayTracable {
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
    
    func deflectionAngle(for dir: Vector, at interface: Line) -> Vector {
        
        let refraction = 1.46
        let extIndex = 1.0
        
        let dirCopy = dir.copy()
        
        // Determine the angle from the normal
        let thetaInc: Radians = dirCopy.angleBetween(interface.normal())
        
        // Snell's Law of reflection
        let deflection: Radians = asin((extIndex * sin(thetaInc)) / refraction)
        
        dirCopy.rotate(by: deflection)
        
        return dirCopy
        
    }
    
    func deflectRay(_ ray: Ray) {
        let interface = self.interface(of: ray.origin)
        ray.direction = deflectionAngle(for: ray.direction, at: interface)
    }
    
    var criticalAngle: Radians {
        let refraction = 1.46
        let extIndex = 1.0
        
        return asin(extIndex / refraction)
    }
    
    func modifyRay(_ ray: Ray) {
        deflectRay(ray)
    }
}
