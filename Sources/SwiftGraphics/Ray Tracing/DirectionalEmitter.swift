//
//  DirectionalEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An emiiter that casts a single ray at a given angle
public class DirectionalEmitter: Circle, Emitter {

    /// Direction of the ray
    public var direction: Degrees

    /// Visual style for the emitter's rays
    public var style: RayTraceStyle = .line

    public var passStyle: Bool = true

    /// Instantiate a new emitter
    /// - Parameters:
    ///   - origin: The emitter's origin
    ///   - direction: Direction of the emitter's ray
    public init(_ origin: Vector, _ direction: Degrees) {
        self.direction = direction

        super.init(center: origin, radius: 10)

    }

    public convenience init(x: Double, y: Double, direction: Degrees) {
        self.init(Vector(x, y), direction)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Draw the emitter and ray trace using the specified `BoundingBox` and objects
    /// - Parameters:
    ///   - boundingBox: `BoundingBox` for ray termination
    ///   - objects: Objects to test for intersection when casting rays
    public func draw(objects: [Intersectable]) {

        let intersections = self.intersections(for: direction.toRadians(),
                           origin: center,
                           objects: objects
        )

        drawIntersections(intersections)

    }

    public override func debugDraw(in context: CGContext) {
        super.debugDraw(in: context)

        let dirPoint = Vector(angle: direction.toRadians())
        dirPoint *= 20
        dirPoint += center

        dirPoint.debugDraw(in: context)
    }

    public override func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return defaultIntersections(for: angle, origin: origin, objects: objects)
    }

}
