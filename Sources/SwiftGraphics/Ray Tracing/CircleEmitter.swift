//
//  CircleEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle that emits rays radiating out from its perimiter
public class CircleEmitter: Circle, Emitter {

    /// Angle of the step between emitted rays
    ///
    /// The value is clamped to a minimum of `0`
    public var rayStep: Degrees {
        didSet {
            if rayStep < 0 {
                rayStep = 0
            }
        }
    }

    /// Visual style for the emitter's rays
    public var style: RayTraceStyle = .line

    /// Instantiate a new emitter at the specified coordinates
    /// - Parameters:
    ///   - x: Center X coordinate
    ///   - y: Center Y coordinate
    ///   - radius: Radius of the emitter
    ///   - rayStep: Angle between emitted rays
    public init(x: Double, y: Double, radius: Double, rayStep: Double) {
        self.rayStep = rayStep
        super.init(x: x, y: y, radius: radius)

    }

    /// Draw the emitter and ray trace using the specified objects
    /// - Parameters:
    ///   - objects: Objects to test for intersection when casting rays
    public func draw(objects: [RayTracable]) {

        // Draw the circle
        if case .line = style {
            super.draw()
        }

        // Nothing to do if there are no rays
        guard rayStep > 0 else { return }

        // Stride through the circle, stepping by degree
        stride(from: rayStep, through: 360, by: rayStep).forEach { angle in
            let rAngle = Double(angle).toRadians()
            let origin = rayIntersection(rAngle)
            let ray = Ray(
                origin: origin,
                direction: Vector(angle: rAngle)
            )
            ray.run(objects: objects)
            self.drawIntersections(ray.path)

        }

    }

}
