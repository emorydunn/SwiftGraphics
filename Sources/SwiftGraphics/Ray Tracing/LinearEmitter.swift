//
//  LinearEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/4/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

public class LinearEmitter: Line, Emitter {

    public var style: RayTraceStyle = .line

    public var rayStep: Double

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

    public func draw(objects: [Intersectable]) {
        // Draw the circle
        if case .line = style {
            super.draw()
        }

        guard rayStep > 0 else { return }

        let angleVector: Vector = normal()
        angleVector.rotate(by: 180.toRadians())
        let angle = angleVector.heading()
        let percentStep = (rayStep / length)

        stride(from: 0, to: 1 + percentStep, by: percentStep).forEach { percent in
            let origin = start + ((end - start) * percent)

            let intersections = self.intersections(
                for: angle,
                origin: origin,
                objects: objects)

            drawIntersections(intersections)

        }

    }

    public override func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return defaultIntersections(for: angle, origin: origin, objects: objects)
    }

}
