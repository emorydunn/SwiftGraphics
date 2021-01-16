//
//  RayTracable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 1/15/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

public class Ray {
    
    public var origin: Vector {
        didSet {
            print("New origin:", origin)
        }
    }
    public var direction: Vector

    public var path: [Line] = []
    
    public var isTerminated: Bool = false
    
    var iterationCount = 0 {
        didSet {
            if iterationCount > 1000 {
                print("Iteration count has crossed threshold")
                terminateRay()
            }
        }
    }
    
    public init(origin: Vector, direction: Vector) {
        self.origin = origin
        self.direction = direction
    }
    
    public convenience init(x: Double, y: Double, direction: Degrees) {
        self.init(
            origin: Vector(x, y),
            direction: Vector(angle: direction.toRadians()))
    }
    
    public func resetPath() {
        path.removeAll()
    }
    
    public func terminateRay() {
        isTerminated = true
    }
    
    /// Draw the emitter and ray trace using the specified objects
    /// - Parameters:
    ///   - objects: Objects to test for intersection when casting rays
    public func draw(objects: [RayTracable]) {
        
        while isTerminated == false {
            var closestDistance = Double.infinity
            var closestObject: RayTracable?
            var closestPoint: Vector?
            
            
            
            // Find the closest intersecting object
            objects.forEach {
                // Find any intersecting points
                guard let intersection = $0.rayIntersection(origin: origin, dir: direction) else { return }
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
            
        
            if let closestObject = closestObject, let closestPoint = closestPoint {
                path.append(Line(origin, closestPoint))
                origin = closestPoint
                closestObject.modifyRay(self)
            } else {
                terminateRay()
            }

            path.draw()
            iterationCount += 1
            
        }
        
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
