//
//  BezierPath.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/30/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import AppKit


/// A parametric curve
public class BezierPath: Shape {
    
    /// A point used to draw a Bézier curve
    public struct Point: Hashable {
        
        /// Anchor point
        let point: Vector

        /// First control point
        let control1: Vector?

        /// Second control point
        let control2: Vector?
        
        /// Instantiate a new Point
        /// - Parameters:
        ///   - point: The point
        ///   - control1: The point's first control point
        ///   - control2: The point's second control point
        public init(point: Vector, control1: Vector? = nil, control2: Vector? = nil) {
            self.point = point
            self.control1 = control1
            self.control2 = control2
        }
    }
    
    /// The starting position of the path
    public var start: Vector
    
    /// The points making up the curve
    public var points: [Point]
    
    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        // FIXME: This needs to be implemented
        Rectangle(x: 0, y: 0, width: 0, height: 0)
    }
    
    /// Instantiate a new Path from an array of Vectors
    /// - Parameter points: Points in the path
    public init(start: Vector, points: [Point] = []) {
        self.start = start
        self.points = points
    }
    
    /// Instantiate a new Bezier from a `Path`
    ///
    /// From: [Smooth a Svg path with cubic bezier curves][bezier]
    ///
    /// [bezier]: https://medium.com/@francoisromain/smooth-a-svg-path-with-cubic-bezier-curves-e37b49d46c74
    /// - Parameter path: The path to transform into a Bézier curve
    public init(_ path: Path, smoothing: Double = 0.2) {
        self.start = path.points[0]
        
        var bezPoints = path.points
        if path.close {
            // Duplicate the first point
            bezPoints.append(path.points[0])
        }

        self.points = bezPoints.enumerated().compactMap { index, point in

            guard let backOne = path.points[safe: index - 1] else {
                return nil
            }
            let control1 = backOne.controlPoint(
                previous: path.points[safe: index - 2],
                next: point,
                smoothing: smoothing
            )

            let control2 = point.controlPoint(
                previous: path.points[safe: index - 1],
                next: path.points[safe: index + 1],
                reverse: true,
                smoothing: smoothing
            )

            return Point(point: point, control1: control1, control2: control2)

        }
    }
}


extension BezierPath: CGDrawable {
    
    func makeBezier() -> NSBezierPath {
        let path = NSBezierPath()
        path.lineJoinStyle = .bevel

        path.move(to: CGPoint(x: start.x, y: start.y))

        points.forEach {
            if let control1 = $0.control1?.nsPoint(), let control2 = $0.control2?.nsPoint() {
                path.curve(
                    to: $0.point.nsPoint(),
                    controlPoint1: control1,
                    controlPoint2: control2
                )
            } else {
                path.line(to: $0.point.nsPoint())
            }
            
        }
        
        return path
    }

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {

        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))

        let path = makeBezier()
        path.stroke()

    }

    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        start.debugDraw(in: context)
        points.forEach {
            $0.point.debugDraw(in: context)
        }
    }

}

extension BezierPath: SVGDrawable {

    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "path")

        let bezPoints = points.map({
            if let control1 = $0.control1, let control2 = $0.control2 {
                return "C \(control1.x),\(control1.y) \(control2.x),\(control2.y) \($0.point.x),\($0.point.y)"
            } else {
                return "L \($0.point.x),\($0.point.y)"
            }

            }).joined(separator: " ")

        let command = "M \(start.x),\(start.y) \(bezPoints)"

        element.addAttribute(command, forKey: "d")

        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
    }

}

extension BezierPath: Hashable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values a and b, a == b implies that a != b is false.
    public static func == (lhs: BezierPath, rhs: BezierPath) -> Bool {
        lhs.start == rhs.start && lhs.points == rhs.points
    }
    
    /// The hash value of the curve
    /// - Parameter hasher: The hasher
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(points)
    }
    
}
