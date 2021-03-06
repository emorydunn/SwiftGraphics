//
//  LinearEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/4/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A Line that emitts evenly spaced rays parallel to its normal. 
public class LinearEmitter: Line, Emitter {

    /// Visual style for the emitter's rays
    public var style: RayTraceStyle = .line

    /// Distance between each ray
    public var rayStep: Double
    
    /// The rays this emitter casts
    var rays: [Ray] = []

    /// Instantiate a new `Line`
    /// - Parameters:
    ///   - start: Starting point
    ///   - end: Ending point
    public init(_ start: Vector, _ end: Vector, rayStep: Double) {
        self.rayStep = rayStep
        super.init(start, end)
    }

    /// Instantiate a new `Line` from coordinates
    /// - Parameters:
    ///   - x1: Starting X coordinate
    ///   - y1: Starting Y coordinate
    ///   - x2: Ending X coordinate
    ///   - y2: Ending Y coordinate
    public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, rayStep: Double) {
         // swiftlint:disable:previous identifier_name
        self.rayStep = rayStep
        super.init(x1, y1, x2, y2)
    }

    /// Process the ray casting operations for this emitter.
    ///
    /// This method calculates the paths of the emitter's rays, but does not draw them.
    /// Any previous rays will be overwritten.
    /// - Parameter objects: The objects with which the rays will interact
    public func run(objects: [RayTracable]) {
        // Draw the line
        if case .line = style {
            super.draw()
        }

        // Ensure there is space between the rays
        guard rayStep > 0 else { return }

        let angleVector: Vector = normal()
        angleVector.rotate(by: 180.toRadians())
        let angle = angleVector.heading()
        let percentStep = (rayStep / length)

        self.rays = stride(from: 0, to: 1 + percentStep, by: percentStep).map { percent in
            let origin = self.lerp(percent)
            
            let ray = Ray(
                origin: origin,
                direction: Vector(angle: angle)
            )
            ray.run(objects: objects)
            return ray

        }
        

    }
    
    /// Draw the paths taken by the emitter's rays.
    ///
    /// This method does not perform any ray tracing.
    public func draw() {
        rays.forEach { self.drawIntersections($0.path) }
    }

}
