//
//  Circle.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle, with an origin and a radius
public class Circle: Polygon, Intersectable, CGDrawable {

    /// Radius of the circle
    public var radius: Double

    /// Center point of the circle
    public var center: Vector

    /// The offset radius, used when calculating intersections with the circle
    public var radiusOffset: Double = 0

    /// The diameter of the circle
    public var diameter: Double { radius * 2 }

    /// The offset radius of the circle
    public var offsetRadius: Double { radius + radiusOffset }

    /// The offset diameter of the circle
    public var offsetDiameter: Double { offsetRadius * 2 }

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
    public init(x: Double, y: Double, radius: Double) {
        self.center = Vector(0, 0)
        self.radius = radius

        self.center = Vector(x, y)

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

    /// Return the intersection point of the specified angle from the center of the circle
    /// - Parameter angle:The angle
    public func rayIntersection(_ theta: Radians) -> Vector {

        let x = center.x + radius * cos(theta)
        let y = center.y + radius * sin(theta)

        return Vector(x, y)
    }

    /// Return the intersection of a ray
    ///
    /// From https://math.stackexchange.com/a/311956
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    public func rayIntersection(origin: Vector, dir: Vector) -> Vector? {

        let relativeDir = dir + origin

        // swiftlint:disable all
        let a = (relativeDir.x - origin.x).squared() + (relativeDir.y - origin.y).squared()
        let b = 2 * (relativeDir.x - origin.x) * (origin.x - center.x) + 2 * (relativeDir.y - origin.y) * (origin.y - center.y)
        let c = (origin.x - center.x).squared() + (origin.y - center.y).squared() - radius.squared()
        // swiftlint:enable all

        let discr = b.squared() - 4 * a * c

        let t = (2 * c) / (-b + sqrt(discr)) // swiftlint:disable:this identifier_name

        // If t is less than 0 the intersection is behind the ray
        guard t > 0 else { return nil }

        let pHit = Vector(
            (relativeDir.x - origin.x) * t + origin.x,
            (relativeDir.y - origin.y) * t + origin.y
        )

        return pHit

    }
    
    /// Returns an empty array, which causes the receiver to terminate the ray.
    public func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return []
    }

    /// Determine the points where the specified `Line` intersects the `Circle`
    ///
    /// Adapted from the C version by [Paul Bourke](http://paulbourke.net/geometry/circlesphere/).
    /// - Parameter line: Intersecting line
    public func lineIntersection(_ line: Line) -> [Vector] {
        
        let deltaLine = line.end - line.start
        
        let a = deltaLine.magSq()
        let b = 2 * (deltaLine.x * (line.start.x - center.x) +
                     deltaLine.y * (line.start.y - center.y) +
                     deltaLine.z * (line.start.z - center.z))
        var c = center.magSq()
        
        c += line.start.magSq()
        c -= 2 * (line.start.dot(center))
        c -= radius.squared()
        
        let bb4ac = b * b - 4 * a * c
        
        let eps: Double = 0.00001

        guard abs(a) > eps || bb4ac > 0  else {
            return []
        }

        var points = [Vector]()
        
        let mu1 = (-b + sqrt(bb4ac)) / (2 * a)
        if mu1 > 0 && mu1 < 1 {
            points.append(line.start + deltaLine * mu1)
        }
        
        let mu2 = (-b - sqrt(bb4ac)) / (2 * a)
        if mu2 > 0 && mu2 < 1 {
            points.append(line.start + deltaLine * mu2)
        }
        
        return points

    }

    /// Determine whether teh specified point is inside the circle
    ///
    /// This method compares the distance between the center and point to the radius of the circle.
    /// - Parameter point: Whether the point is inside the circle
    public func contains(_ point: Vector) -> Bool {
        return point.dist(center) < radius
    }

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {

        context.saveGState()
        context.translateBy(x: CGFloat(-radius), y: CGFloat(-radius))
        let bb = CGRect(x: center.x, y: center.y, width: diameter, height: diameter)

        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))
        context.strokeEllipse(in: bb)
        context.fillEllipse(in: bb)

        context.restoreGState()
    }

    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        draw(in: context)
    }
}

extension Circle: SVGDrawable {

    /// Create a `XMLElement` representing the receiver
    public func svgElement() -> XMLElement {
        let element = XMLElement(kind: .element)
        element.name = "circle"
        element.addAttribute(center.x, forKey: "cx")
        element.addAttribute(center.y, forKey: "cy")
        element.addAttribute(radius, forKey: "r")

        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
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
