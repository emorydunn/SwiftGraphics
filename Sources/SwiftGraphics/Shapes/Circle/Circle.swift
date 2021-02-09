//
//  Circle.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle, with an origin and a radius
public class Circle {

    /// Radius of the circle
    public var radius: Double

    /// Center point of the circle
    public var center: Vector

    /// The diameter of the circle
    public var diameter: Double { radius * 2 }

    /// Instantiate a new `Circle`
    /// - Parameters:
    ///   - center: Center of the circle
    ///   - radius: Radius of the circle
    public init(center: Vector, radius: Double) {
        self.center = center
        self.radius = radius
    }

    /// Instantiate a new `Circle`
    /// - Parameters:
    ///   - x: Center X coordinate
    ///   - y: Center Y coordinate
    ///   - radius: Radius of the circle
    public convenience init(x: Double, y: Double, radius: Double) {
        self.init(center: Vector(x, y), radius: radius)

    }

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        Rectangle(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }

    
    /// Generate a cubic Bézier representing an arc around a circle.
    ///
    /// Adapted from [Joe Cridge](https://www.joecridge.me/bezier.pdf)
    /// - Note: Bézier approximations of circles only work up to ~90º
    /// - Parameters:
    ///   - start: Starting angle of the arc, in radians
    ///   - size: Size of the arc, in radians
    ///   - circle: Circle to make the arc on
    public func acuteArc(start: Radians, size: Radians) -> BezierPath {
        
        let alpha = size / 2
        let cosAlpha = cos(alpha)
        let sinAlpha = sin(alpha)
        let cotAlpha = 1 / tan(alpha)
        
        let phi = start + alpha  // This is how far the arc needs to be rotated.
        let cosPhi = cos(phi)
        let sinPhi = sin(phi)
        
        let lambda = (4 - cosAlpha) / 3
        // swiftlint:disable:next identifier_name
        let mu = sinAlpha + (cosAlpha - lambda) * cotAlpha
        
        let pointA = Vector(cos(start), sin(start)) * radius + center
        let pointB = Vector(
            lambda * cosPhi + mu * sinPhi,
            lambda * sinPhi - mu * cosPhi
            ) * radius + center
        let pointC = Vector(
            lambda * cosPhi - mu * sinPhi,
            lambda * sinPhi + mu * cosPhi
            ) * radius + center
        let pointD = Vector(cos(start + size), sin(start + size)) * radius + center
        
        let points = [
            BezierPath.Point(point: pointD,
                             control1: pointB,
                             control2: pointC)
        ]
        
        return BezierPath(start: pointA, points: points)
    }
}


extension Circle: Hashable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values a and b, a == b implies that a != b is false.
    public static func == (lhs: Circle, rhs: Circle) -> Bool {
        lhs.center == rhs.center && lhs.radius == rhs.radius
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(center)
        hasher.combine(radius)
    }

}


extension Circle: Polygon {
    
    /// Return the intersection point of the specified angle from the center of the circle
    /// - Parameter angle:The angle
    public func point(at angle: Radians) -> Vector {
        
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        return Vector(x, y)
    }
    
    public func angle(ofPoint point: Vector) -> Radians {
        let unitInt = point - center
        return atan2(unitInt.y, unitInt.x)
    }
    
    /// Determine whether teh specified point is inside the circle
    ///
    /// This method compares the distance between the center and point to the radius of the circle.
    /// - Parameter point: Whether the point is inside the circle
    public func contains(_ point: Vector) -> Bool {
        let unitPoint = point - center
        return sqrt(unitPoint.x.squared() + unitPoint.y.squared()) < radius
    }
}
