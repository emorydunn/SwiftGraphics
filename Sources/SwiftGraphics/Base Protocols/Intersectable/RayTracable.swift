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

public protocol RayTracable: Intersectable {
    func modifyRay(_ ray: Ray)
}

public extension RayTracable {
    func modifyRay(_ ray: Ray) {
        ray.terminateRay()
    }
}


extension Circle: RayTracable {
    public func modifyRay(_ ray: Ray) {
        deflectRay(ray)
    }
}
extension Rectangle: RayTracable { }
extension Line: RayTracable { }
