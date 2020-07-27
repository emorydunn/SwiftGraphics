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

    /// A point used to draw a Bézier curve
    public struct BezierPoint {
        /// Anchor point
        let point: Vector

        /// First control point
        let control1: Vector

        /// Second control point
        let control2: Vector
    }

    /// Drawing style of the Path
    public enum Style {

        /// Draw straight lines connecting each point
        case sharp

        /// Draw a cubic Bézier curve between points
        case smooth
    }

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        Rectangle(x: 0, y: 0, width: 0, height: 0)
    }

    /// Points that make up the path
    public var points: [Vector]

    /// Amount to smooth the Bézier curve
    public var smoothing = 0.2

    /// Drawing style of the Path
    public var style: Style = .smooth

    /// Whether to close the path
    ///
    /// This is done by appending the first point to the end of `points` while drawing
    public var close: Bool = false

    /// Instantiate a new Path from an array of Vectors
    /// - Parameter points: Points in the path
    public init(points: [Vector] = []) {
        self.points = points
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

    /// Calculate a control point tangent to the curve of the specified `Vector`
    /// - Parameters:
    ///   - current: The current point
    ///   - previous: The previous point in the path
    ///   - next: The next point in the path
    ///   - reverse: Whether to rotate the control point 180º
    func controlPoint(of current: Vector, previous: Vector?, next: Vector?, reverse: Bool = false) -> Vector {
        // When 'current' is the first or last point of the array
        // 'previous' or 'next' don't exist.
        // Replace with 'current'
        let prevPoint = previous ?? current
        let nextPoint = next ?? current

        // Properties of the opposed-line
        let lengthX = nextPoint.x - prevPoint.x
        let lengthY = nextPoint.y - prevPoint.y

        let length = sqrt(lengthX.squared() + lengthY.squared()) * smoothing
        var angle = atan2(lengthY, lengthX)

        // If is end-control-point, add PI to the angle to go backward
        angle += reverse ? Double.pi : 0

        // The control point position is relative to the current point
        let x = current.x + cos(angle) * length
        let y = current.y + sin(angle) * length

        return Vector(x, y)
    }

    /// Create  a smooth Bézier curve
    ///
    /// From: [Smooth a Svg path with cubic bezier curves][bezier]
    ///
    /// [bezier]: https://medium.com/@francoisromain/smooth-a-svg-path-with-cubic-bezier-curves-e37b49d46c74
    public func smoothLine() -> [BezierPoint] {

        var bezPoints = points
        if close {
            // Duplicate the first point
            bezPoints.append(points[0])
        }

        return bezPoints.enumerated().compactMap { index, point in

            guard let backOne = points[safe: index - 1] else {
                return nil
            }
            let control1 = controlPoint(
                of: backOne,
                previous: points[safe: index - 2],
                next: point
            )

            let control2 = controlPoint(
                of: point,
                previous: points[safe: index - 1],
                next: points[safe: index + 1],
                reverse: true
            )

            return BezierPoint(point: point, control1: control1, control2: control2)

        }

    }

}

extension Path: CGDrawable {

    /// Create a `NSBezierPath` drawn with straight lines
    func sharpLine() -> NSBezierPath {
        let path = NSBezierPath()

        path.move(to: CGPoint(x: points[0].x, y: points[0].y))

        points.forEach { point in
            path.line(to: point.nsPoint())
        }

        return path
    }

    /// Create a `NSBezierPath` drawn with a Bézier curve
    func smoothLine() -> NSBezierPath {
        
        let path = NSBezierPath()
        path.lineJoinStyle = .bevel

        let bezPoints: [BezierPoint] = smoothLine()

        path.move(to: CGPoint(x: points[0].x, y: points[0].y))

        bezPoints.forEach {
            path.curve(
                to: $0.point.nsPoint(),
                controlPoint1: $0.control1.nsPoint(),
                controlPoint2: $0.control2.nsPoint()
            )
        }

        return path
    }

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {

        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))

        let path: NSBezierPath
        switch style {
        case .sharp:
            path = sharpLine()
        case .smooth:
            path = smoothLine()
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

    /// Create a `XMLElement` drawn with straight lines
    func sharpLine() -> XMLElement {
        let element = XMLElement(kind: .element)
        element.name = "path"

        let lines = points.map({
            "L \($0.x) \($0.y)"
            }).joined(separator: " ")

        let command = "M \(points[0].x),\(points[0].y) \(lines)"

        element.addAttribute(command, forKey: "d")

        return element
    }

    /// Create a `XMLElement` drawn with a Bézier curve
    func smoothLine() -> XMLElement {
        let element = XMLElement(kind: .element)
        element.name = "path"

        let bezPoints = smoothLine().map({
            "C \($0.control1.x),\($0.control1.y) \($0.control2.x),\($0.control2.y) \($0.point.x),\($0.point.y)"
            }).joined(separator: " ")

        let command = "M \(points[0].x),\(points[0].y) \(bezPoints)"

        element.addAttribute(command, forKey: "d")

        return element
    }

    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element: XMLElement
        switch style {
        case .sharp:
            element = sharpLine()
        case .smooth:
            element = smoothLine()
        }

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
