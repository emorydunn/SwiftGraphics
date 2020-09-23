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
    
    public func angle(ofPoint point: Vector) -> Radians {
        let unitInt = point - center
        return atan2(unitInt.y, unitInt.x)
    }

    /// Return the intersection of a ray
    ///
    /// From https://math.stackexchange.com/a/311956
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    public func rayIntersection(origin: Vector, dir: Vector) -> Vector? {

        guard let hitPoints = rayIntersections(origin: origin, dir: dir) else { return nil }

        if hitPoints.entry.inLine {
            return hitPoints.entry.point
        } else if hitPoints.exit.inLine {
            return hitPoints.exit.point
        }

        return nil
        
    }
    
    /// Return the entry and exit points for the given ray
    ///
    /// From https://math.stackexchange.com/a/311956
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    public func rayIntersections(origin: Vector, dir: Vector) -> (entry: IntersectionInfo, exit: IntersectionInfo)? {

        let relativeDir = dir + origin

        // swiftlint:disable all
        let a = (relativeDir.x - origin.x).squared() + (relativeDir.y - origin.y).squared()
        let b = 2 * (relativeDir.x - origin.x) * (origin.x - center.x) + 2 * (relativeDir.y - origin.y) * (origin.y - center.y)
        let c = (origin.x - center.x).squared() + (origin.y - center.y).squared() - radius.squared()
        // swiftlint:enable all

        let discr = b.squared() - 4 * a * c
    
        guard discr > 0 else { return nil }

        let tEntry = (2 * c) / (-b + sqrt(discr))
        let tExit =  (2 * c) / (-b - sqrt(discr))

        let pEntry = Vector(
            (relativeDir.x - origin.x) * tEntry + origin.x,
            (relativeDir.y - origin.y) * tEntry + origin.y
        )
        
        let entryInfo = IntersectionInfo(point: pEntry, inLine: tEntry >= 0 )
        
        let pExit = Vector(
            (relativeDir.x - origin.x) * tExit + origin.x,
            (relativeDir.y - origin.y) * tExit + origin.y
        )
        let exitInfo = IntersectionInfo(point: pExit, inLine: tExit >= 0 )

        return (entryInfo, exitInfo)

    }
    
    /// Returns an empty array, which causes the receiver to terminate the ray.
    public func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return []
    }


    /// Determine whether teh specified point is inside the circle
    ///
    /// This method compares the distance between the center and point to the radius of the circle.
    /// - Parameter point: Whether the point is inside the circle
    public func contains(_ point: Vector) -> Bool {
        let unitPoint = point - center
        return sqrt(unitPoint.x.squared() + unitPoint.y.squared()) < radius
//        return point.dist(center)
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

extension Circle: SVGDrawable {

    /// Create a `XMLElement` representing the receiver
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "circle")

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

extension Circle {
    
    /// Information about ray intersections
    public struct IntersectionInfo {
        /// The intersection point
        public let point: Vector
        
        /// Whether the point is in front of the ray
        public let inLine: Bool
    }
}
