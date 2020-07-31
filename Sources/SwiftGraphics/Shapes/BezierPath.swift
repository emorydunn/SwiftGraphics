//
//  BezierPath.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/30/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import AppKit

public class BezierPath: Shape {
    /// A point used to draw a Bézier curve
    
    public struct Point: Hashable {
        
        /// Anchor point
        let point: Vector

        /// First control point
        let control1: Vector

        /// Second control point
        let control2: Vector
        
        public init(point: Vector, control1: Vector, control2: Vector) {
            self.point = point
            self.control1 = control1
            self.control2 = control2
        }
    }
    
    public var start: Vector
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
}


extension BezierPath: CGDrawable {

    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {

        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))

        let path = NSBezierPath()
        path.lineJoinStyle = .bevel

        path.move(to: CGPoint(x: start.x, y: start.y))

        points.forEach {
            path.curve(
                to: $0.point.nsPoint(),
                controlPoint1: $0.control1.nsPoint(),
                controlPoint2: $0.control2.nsPoint()
            )
        }
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
            "C \($0.control1.x),\($0.control1.y) \($0.control2.x),\($0.control2.y) \($0.point.x),\($0.point.y)"
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
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(points)
    }
    
}
