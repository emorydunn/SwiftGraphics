//
//  DirectionalEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An emiiter that casts a single ray at a given angle
public class DirectionalEmitter: Emitter {

    public var origin: Vector
    public var direction: Vector

    /// Visual style for the emitter's rays
    public var style: RayTraceStyle = .line


    /// Instantiate a new emitter
    /// - Parameters:
    ///   - origin: The emitter's origin
    ///   - direction: Direction of the emitter's ray
    public init(_ origin: Vector, _ direction: Degrees) {
        self.origin = origin
        self.direction = Vector(angle: direction.toRadians())

    }
    
    /// Instantiate a new emitter
    /// - Parameters:
    ///   - x: `x` coordinate of the origin
    ///   - y: `y` coordinate of the origin
    ///   - direction: Direction of the emitter's ray
    public convenience init(x: Double, y: Double, direction: Degrees) {
        self.init(Vector(x, y), direction)
    }

    /// Draw the emitter and ray trace using the specified objects
    /// - Parameters:
    ///   - objects: Objects to test for intersection when casting rays
    public func draw(objects: [RayTracable]) {
        let ray = Ray(origin: origin.copy(), direction: direction.copy())
        ray.run(objects: objects)

        self.drawIntersections(ray.path)

    }
    
    /// Draws a representation of the emitter suitable for debugging.
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        let ray = Ray(origin: origin.copy(), direction: direction.copy())
        ray.debugDraw(in: context)
    }

}
