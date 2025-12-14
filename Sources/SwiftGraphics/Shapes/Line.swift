//
//  Line.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import CoreGraphics

/// Represents a line between two points
open class Line: Shape, Intersectable, RayTracable {

    /// The starting point of the line
    public var start: Vector

    /// The ending point of the line
    public var end: Vector

    /// The length of the line
    public var length: Double { end.dist(start) }

    /// The midpoint of the line
    public var center: Vector {
        get {
            Vector(
                (end.x + start.x) / 2,
                (end.y + start.y) / 2
            )
        }
        set {
            
        }
        
    }

    /// Instantiate a new `Line`
    /// - Parameters:
    ///   - start: Starting point
    ///   - end: Ending point
    public init(_ start: Vector, _ end: Vector) {
        self.start = start
        self.end = end
    }

    /// Instantiate a new `Line` from coordinates
    /// - Parameters:
    ///   - x1: Starting X coordinate
    ///   - y1: Starting Y coordinate
    ///   - x2: Ending X coordinate
    ///   - y2: Ending Y coordinate
    public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) { // swiftlint:disable:this identifier_name
        self.start = Vector(x1, y1)
        self.end = Vector(x2, y2)
    }
    
    /// Instantiate a new `Line` from a center point
    /// - Parameters:
    ///   - center: The center of the line
    ///   - direction: The direction of the line
    ///   - length: The length of the line
    public convenience init(center: Vector, direction: Radians, length: Double) {
        let dir = Vector(angle: direction)
        self.init(
            center.x - dir.x * (length / 2),
            center.y - dir.y * (length / 2),
            center.x + dir.x * (length / 2),
            center.y + dir.y * (length / 2)
        )
    }
    
    /// Instantiate a new `Line` from an origin of a specified length
    /// - Parameters:
    ///   - origin: The origin of the line
    ///   - direction: The direction of the line
    ///   - length: The length of the line
    public convenience init(origin: Vector, direction: Radians, length: Double) {
        let dir = Vector(angle: direction)
        self.init(
            origin.x,
            origin.y,
            origin.x + dir.x * length,
            origin.y + dir.y * length
        )
    }

    /// Determine whether a point is on the line
    ///
    /// From https://gamedev.stackexchange.com/a/57746
    ///
    /// - Parameter point: Whether the point is on the line
    public func contains(_ point: Vector) -> Bool {
        return start + (end - start) * (start.dist(point)) / end.dist(start) == point
    }

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {

        Rectangle(
            x: min(start.x, end.x),
            y: min(start.y, end.y),
            width: abs(end.x - start.x),
            height: abs(end.y - start.y)
        )

    }

    /// Calculate the vector normal of the line
    ///
    /// - Returns: A `Vector` whose heading is perpendicular to the line
    public func normal() -> Vector {
        //calculate base top normal
        let baseDelta = end - start
        baseDelta.normalize()
        let normal = Vector(-baseDelta.y, baseDelta.x)

        return normal
    }

    /// Returns the angle of the line based on the slope
    public func angle() -> Radians {
        return atan(slope())
    }

    /// Calculate the intersection point of a ray and a plane defined by the Line
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    /// - Returns: The point of intersection, if the ray intersections the plane
    public func rayPlaneIntersection(origin: Vector, dir: Vector) -> Vector? {
        let denom = normal().dot(dir)

        let p0 = center - origin // swiftlint:disable:this identifier_name
        let t = p0.dot(normal()) / denom // swiftlint:disable:this identifier_name

        guard t >= 0 else { return nil }
        let pHit = origin + (dir * t)

        // FIXME: A point is returned when ray is parallel to line
        return pHit

    }

    /// Return a point at the specified distance of the line
    /// - Parameter distance: Distance from the end point
    public func point(at distance: Double) -> Vector {
        let v = end - start // swiftlint:disable:this identifier_name
        v.normalize()
        v *= distance

        return start + v
    }

    ///  Linear interpolate the vector to another vector
    /// - Parameter percent: the amount of interpolation; some value between 0.0 and 1.0
    /// - Returns: A Vector between the original two
    public func lerp(_ percent: Double) -> Vector {
        return start + ((end - start) * percent)
    }

    func slope() -> Double {
        return (end.y - start.y) / (end.x - start.x)
    }
    
    // MARK: RayTracable
    /// Calculate the intersection point of a ray and the Line
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    /// - Returns: The point of intersection, if the ray intersections the line
    public func rayIntersection(_ ray: Ray) -> Vector? {
        
        let v1 = ray.origin - start // swiftlint:disable:this identifier_name
        let v2 = end - start // swiftlint:disable:this identifier_name
        let v3 = Vector(-ray.direction.y, ray.direction.x) // swiftlint:disable:this identifier_name
        
        let dot = v2.dot(v3)
        
        let t1 = v2.crossProduct(v1) / dot  //Vector.crossProduct(v2, v1) / dot // swiftlint:disable:this identifier_name
        let t2 = v1.dot(v3) / dot // swiftlint:disable:this identifier_name
        
        // Guard against the intersection point being nearly the same as the origin
        guard t1.rounded() != 0 else {
            return nil
        }
        if t1 >= 0.0 && (t2 >= 0.0 && t2 <= 1.0) {
            return ray.origin + ray.direction * t1
        }
        return nil
    }
    
    public func modifyRay(_ ray: Ray) {
        ray.terminateRay()
    }


}

extension Line: CGDrawable {

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {
        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))
        context.strokeLineSegments(between: [start.cgPoint, end.cgPoint])
    }

    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        let normal = self.normal()

        context.setStrokeColor(.init(red: 255, green: 0, blue: 128, alpha: 1))
        Line(
            center.x,
            center.y,
            center.x - normal.x * 50,
            center.y - normal.y * 50
        ).draw()

        context.setStrokeColor(.init(gray: 0.5, alpha: 1))
        self.draw(in: context)

    }
}

extension Line: SVGDrawable {

    /// Create a `XMLElement` representing the receiver
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "line")
        
        element.addAttribute(start.x, forKey: "x1")
        element.addAttribute(start.y, forKey: "y1")
        element.addAttribute(end.x, forKey: "x2")
        element.addAttribute(end.y, forKey: "y2")

        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")

        return element
    }
}

extension Line: CustomStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        "Line (\(start.x), \(start.y)) → (\(end.x), \(end.y))"
    }
}

extension Line: Hashable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values a and b, a == b implies that a != b is false.
    public static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(end)
    }

}
