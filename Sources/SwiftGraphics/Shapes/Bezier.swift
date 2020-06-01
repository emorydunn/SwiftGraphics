//
//  Bezier.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/31/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import AppKit

public class Bezier: Shape {
    
    public struct BezierPoint {
        let point: Vector
        let control1: Vector
        let control2: Vector
    }
    
    public enum Style {
        case sharp, smooth
    }
    
    public var boundingBox: Rectangle {
        Rectangle(x: 0, y: 0, width: 0, height: 0)
    }
    
    public var points: [Vector]
    
    public var smoothing = 0.2
    public var style: Style = .smooth
    public var close: Bool = true
    
    public init(points: [Vector] = []) {
        self.points = points
    }
    
    public func addPoint(_ point: Vector) {
        self.points.append(point)
    }
    
    public func addPoints(_ points: [Vector]) {
        self.points.append(contentsOf: points)
    }
    
    public func addPoints(_ other: Bezier) {
        self.points.append(contentsOf: other.points)
    }
    
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
        
        print(length, angle)
        
        // The control point position is relative to the current point
        let x = current.x + cos(angle) * length
        let y = current.y + sin(angle) * length
        
        return Vector(x, y)
    }
    
    /// Create  a smooth Bézier curve
    ///
    /// From: [Smooth a Svg path with cubic bezier curves](https://medium.com/@francoisromain/smooth-a-svg-path-with-cubic-bezier-curves-e37b49d46c74)
    public func smoothLine() -> [BezierPoint] {

        var bezPoints = points
        if close {
            // Duplicate the first point
            bezPoints.append(points[0])
        }
        
        return bezPoints.enumerated().compactMap { index, point in
            print("Adding \(index) \(point)")
            
            guard let backOne = points.safeElement(index - 1) else {
                print("No index at \(index - 1)")
                return nil
            }
            let control1 = controlPoint(
                of: backOne,
                previous: points.safeElement(index - 2),
                next: point
            )
            
            let control2 = controlPoint(
                of: point,
                previous: points.safeElement(index - 1),
                next: points.safeElement(index + 1),
                reverse: true
            )
            
            return BezierPoint(point: point, control1: control1, control2: control2)

        }

    }
    
}

extension Bezier: CGDrawable {
    
    func sharpLine() -> NSBezierPath {
        let path = NSBezierPath()
        
        path.move(to: CGPoint(x: points[0].x, y: points[0].y))
        
        points.forEach { point in
            path.line(to: point.nsPoint())
        }
        
        return path
    }
    
    /// Create  a smooth Bézier curve
    ///
    /// From: [Smooth a Svg path with cubic bezier curves](https://medium.com/@francoisromain/smooth-a-svg-path-with-cubic-bezier-curves-e37b49d46c74)
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
    
    public func debugDraw(in context: CGContext) {
        points.forEach {
            $0.debugDraw(in: context)
        }
    }
    
    
}

extension Bezier: SVGDrawable {
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

