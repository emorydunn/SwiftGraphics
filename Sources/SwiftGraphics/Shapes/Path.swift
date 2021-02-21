//
//  Bezier.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/31/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import AppKit

/// Represents a multi-point path
public class Path: Shape {

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        // FIXME: This needs to be implemented
        Rectangle(x: 0, y: 0, width: 0, height: 0)
    }

    /// Points that make up the path
    public var points: [Vector]

    /// Whether to close the path
    ///
    /// This is done by appending the first point to the end of `points` while drawing
    public var close: Bool = false

    /// Instantiate a new Path from an array of Vectors
    /// - Parameter points: Points in the path
    public init(points: [Vector] = []) {
        self.points = points
    }
    
    /// Instantiate a new Path from an array of Vectors
    /// - Parameter points: Points in the path
    public convenience init(point: Vector) {
        self.init(points: [point])
    }
    
    /// Instantiate a new Path from a Bézier curve
    /// - Parameter bezier: The curve it convert to sharp lines
    public convenience init(_ bezier: BezierPath) {
        self.init(points: bezier.points.map(\.point))
    }

    /// Append a point to the path
    /// - Parameter point: New Vector
    public func addPoint(_ point: Vector) {
        self.points.append(point)
    }

    /// Append an array of points to the path
    /// - Parameter point: New Vectors
    public func addPoints(_ points: [Vector]) {
        self.points.append(contentsOf: points)
    }

    /// Append the points of another Path
    /// - Parameter other: The other Path
    public func addPoints(_ other: Path) {
        self.points.append(contentsOf: other.points)
    }

    /// Create  a smooth Bézier curve
    ///
    /// From: [Smooth a Svg path with cubic bezier curves][bezier]
    ///
    /// [bezier]: https://medium.com/@francoisromain/smooth-a-svg-path-with-cubic-bezier-curves-e37b49d46c74
    @available(*, deprecated, message: "Use BezierPath(_:smoothing:) instead.")
    public func smoothLine() -> BezierPath {
        return BezierPath(self)
    }

}

extension Path: CGDrawable {

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {

        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))

        let path = NSBezierPath()

        path.move(to: CGPoint(x: points[0].x, y: points[0].y))

        points.forEach { point in
            path.line(to: point.nsPoint())
        }
        
        if close {
            path.line(to: CGPoint(x: points[0].x, y: points[0].y))
        }

        path.stroke()

    }

    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        points.forEach {
            $0.debugDraw(in: context)
        }
    }

}

extension Path: SVGDrawable {

    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "path")

        let lines = points.map({
            "L \($0.x) \($0.y)"
            }).joined(separator: " ")

        let command = "M \(points[0].x),\(points[0].y) \(lines)"

        element.addAttribute(command, forKey: "d")

        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
    }

}

extension Path: Hashable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values a and b, a == b implies that a != b is false.
    public static func == (lhs: Path, rhs: Path) -> Bool {
        lhs.points == rhs.points
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(points)
    }
    
}
