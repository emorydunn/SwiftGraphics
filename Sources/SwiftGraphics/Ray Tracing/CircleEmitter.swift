//
//  CircleEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle that emits rays radiating out from its perimeter
public class CircleEmitter: Circle, Emitter {

    /// Angle of the step between emitted rays
    ///
    /// The value is clamped to a minimum of `0`
    public var rayStep: Int {
        didSet {
            if rayStep < 1 {
                rayStep = 1
            }
        }
    }

    /// Visual style for the emitter's rays
    public var style: RayTraceStyle = .line
    
    /// The rays this emitter casts
    public var rays: [Ray] = []

    /// Instantiate a new emitter at the specified coordinates
    /// - Parameters:
    ///   - x: Center X coordinate
    ///   - y: Center Y coordinate
    ///   - radius: Radius of the emitter
    ///   - rayStep: Angle between emitted rays
    public init(x: Double, y: Double, radius: Double, rayStep: Int) {
        self.rayStep = rayStep
        super.init(center: Vector(x, y), radius: radius)

    }
    
    
    /// Process the ray casting operations for this emitter.
    ///
    /// This method calculates the paths of the emitter's rays, but does not draw them.
    /// Any previous rays will be overwritten.
    /// - Parameter objects: The objects with which the rays will interact
    public func run(objects: [RayTracable]) {
        
        // Nothing to do if there are no rays
        guard rayStep > 0 else { return }
        
        
        // TODO: Replace this with pointsDistributed(every: Degrees)
        // Stride through the circle, stepping by degree
        self.rays = stride(from: 0.0, to: 360, by: 360 / Double(rayStep)).map { angle in
            let rAngle = Double(angle).toRadians()
            let origin = point(at: rAngle)
            let ray = Ray(
                origin: origin,
                direction: Vector(angle: rAngle)
            )
            ray.run(objects: objects)
            return ray

        }
    }

    /// Draw the paths taken by the emitter's rays.
    ///
    /// This method does not perform any ray tracing.
    public func draw() {
        
        // Draw the circle
        if case .line = style {
            super.draw()
        }

        rays.forEach { self.drawIntersections($0.path) }
        

    }

}
