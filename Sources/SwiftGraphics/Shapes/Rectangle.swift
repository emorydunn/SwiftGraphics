//
//  Rectangle.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A rectangle
open class Rectangle: Polygon, CGDrawable, SVGDrawable {

    /// Origin X coordinate
    public var x: Double

    /// Origin Y coordinate
    public var y: Double

    /// Width of the rectangle
    public var width: Double

    /// Height of the rectangle
    public var height: Double

    /// Instantiate a new `Rectangle`
    /// - Parameters:
    ///   - x: Origin X coordinate
    ///   - y: Origin Y coordinate
    ///   - width: Width of the rectangle
    ///   - height: Height of the rectangle
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    /// Instantiate a new `Rectangle`
    /// - Parameters:
    ///   - x: Origin X coordinate
    ///   - y: Origin Y coordinate
    ///   - width: Width of the rectangle
    ///   - height: Height of the rectangle
    public init(centerX: Double, centerY: Double, width: Double, height: Double) {
        self.x = centerX - width / 2
        self.y = centerY - height / 2

        self.width = width
        self.height = height
    }

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle { self }

    /// Returns the coordinates of the center of the Rectangle
    public var center: Vector {
        get {
            Vector(self.x + width / 2,
                   self.y + height / 2)
        }
        set {
            self.x = newValue.x - width / 2
            self.y = newValue.y - height / 2
        }
    }

    /// A `Line` representing the top edge
    public var topEdge: Line {
        Line(topLeft, topRight)
    }

    /// A `Line` representing the bottom edge
    public var bottomEdge: Line {
        Line(bottomLeft, bottomRight)
    }

    /// A `Line` representing the left edge
    public var leftEdge: Line {
        Line(topLeft, bottomLeft)
    }

    /// A `Line` representing the right edge
    public var rightEdge: Line {
        Line(topRight, bottomRight)
    }

    /// Coordinate of the top-left corner
    public var topLeft: Vector {
        Vector(minX,
               minY)
    }

    /// Coordinate of the top-right corner
    public var topRight: Vector {
        Vector(maxX,
               minY)
    }

    /// Coordinate of the bottom-left corner
    public var bottomLeft: Vector {
        Vector(minX,
               maxY)
    }

    /// Coordinate of the botom-left corner
    public var bottomRight: Vector {
        Vector(maxX,
               maxY)
    }

    public var minX: Double { x }
    public var minY: Double { y }

    public var maxX: Double { x + width }
    public var maxY: Double { y + height }

    /// Returns the point on the rectangle where the specified angle originating from the center intersects
    /// - Parameter theta: Angle in radians
    public func rayIntersection(_ theta: Radians) -> Vector {
        return rayIntersection(origin: self.center, theta: theta)!

    }

    /// Determine whether the specified point is in the rectangle
    ///
    /// Tests whether the point is between the left and right edges, and top and bottom edges
    /// - Parameter point: Whether the point is inside the rectangle
    public func contains(_ point: Vector) -> Bool {
        let withinX = point.x > minX && point.x < maxX
        let withinY = point.y > minY && point.y < maxY

        return withinX && withinY
    }

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    open func draw(in context: CGContext) {
        let rect = CGRect(x: x, y: y, width: width, height: height)

        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))
        context.stroke(rect)
        context.fill(rect)
    }

    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    open func debugDraw(in context: CGContext) {

        let tlColor = CGColor(red: 255 / 255, green: 159 / 255, blue: 82 / 255, alpha: 1)
        let trColor = CGColor(red: 82 / 255, green: 243 / 255, blue: 255 / 255, alpha: 1)
        let brColor = CGColor(red: 163 / 255, green: 82 / 255, blue: 255 / 255, alpha: 1)
        let blColor = CGColor(red: 255 / 255, green: 82 / 255, blue: 82 / 255, alpha: 1)

        context.setFillColor(tlColor)
        context.setStrokeColor(tlColor)
        Circle(center: topLeft, radius: 5).draw()
        topEdge.draw()

        context.setFillColor(trColor)
        context.setStrokeColor(trColor)
        Circle(center: topRight, radius: 5).draw()
        rightEdge.draw()

        context.setFillColor(brColor)
        context.setStrokeColor(brColor)
        Circle(center: bottomRight, radius: 5).draw()
        bottomEdge.draw()

        context.setFillColor(blColor)
        context.setStrokeColor(blColor)
        Circle(center: bottomLeft, radius: 5).draw()
        leftEdge.draw()

    }

    /// Create a `XMLElement` representing the receiver
    open func svgElement() -> XMLElement {
        let element = XMLElement(kind: .element)
        element.name = "rect"
        element.addAttribute(x, forKey: "x")
        element.addAttribute(y, forKey: "y")
        element.addAttribute(width, forKey: "width")
        element.addAttribute(height, forKey: "height")

        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
    }
}

extension Rectangle: Intersectable {

    /// Calculate the intersection point of a ray and the the Rectangle
    ///
    /// Adapted from [Amy Williams et al.][3d]
    ///
    /// [3d]:  https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-box-intersection
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    /// - Returns: The point of intersection, if the ray intersections the line
    public func rayIntersection(origin: Vector, dir: Vector) -> Vector? {

        let invDir = 1 / dir

        // Calculate X Coordinate
        var tmin: Double
        var tmax: Double
        if invDir.x >= 0 {
            tmin = (minX - origin.x) * invDir.x
            tmax = (maxX - origin.x) * invDir.x
        } else {
            tmin = (maxX - origin.x) * invDir.x
            tmax = (minX - origin.x) * invDir.x
        }

        // Calculate Y Coordinate
        let tymin: Double
        let tymax: Double
        if invDir.y >= 0 {
            tymin = (minY - origin.y) * invDir.y
            tymax = (maxY - origin.y) * invDir.y
        } else {
            tymin = (maxY - origin.y) * invDir.y
            tymax = (minY - origin.y) * invDir.y
        }

        if (tmin > tymax) || (tymin > tmax) {
            return nil
        }

        if tymin > tmin {
            tmin = tymin
        }
        if tymax < tmax {
            tmax = tymax
        }

        var t = tmin // swiftlint:disable:this identifier_name
        if t < 0 {
            t = tmax
            if t < 0 { return nil }
        }

        return origin + dir * t

    }

    /// Determine where the specified line intersects with the rectangle
    ///
    /// The rectangle tests whether the line intersects with each of its four edges
    /// - Parameter line: The line to test
    public func lineIntersection(_ line: Line) -> [Vector] {
        // Collect the edges
        let edges = [
            topEdge,
            bottomEdge,
            leftEdge,
            rightEdge
        ]

        return edges.reduce(into: [Vector]()) { (intersections, edge) in
            intersections.append(contentsOf: edge.lineIntersection(line))

        }

    }

    public func intersections(for angle: Radians, origin: Vector, objects: [Intersectable]) -> [Line] {
        return []
    }

}

extension Rectangle: Equatable {
    public static func == (lhs: Rectangle, rhs: Rectangle) -> Bool {
        lhs.x == rhs.x &&
            lhs.y == rhs.y &&
            lhs.width == rhs.width &&
            lhs.height == rhs.height
    }

}
