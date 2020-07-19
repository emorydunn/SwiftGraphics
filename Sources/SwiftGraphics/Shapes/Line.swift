//
//  Line.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Represents a line between two points
open class Line: Shape, Intersectable {
    
    /// The starting point of the line
    public var start: Vector
    
    /// The ending point of the line
    public var end: Vector
    
    /// The length of the line
    public var length: Double { end.dist(start) }
    
    /// The midpoint of the line
    public var center: Vector {
        return Vector(
            (end.x + start.x) / 2,
            (end.y + start.y) / 2
        )
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
    public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
        self.start = Vector(x1, y1)
        self.end = Vector(x2, y2)
    }
    
    /// Determine whether a point is on the line
    /// - Parameter point: Whether the point is on the line
    public func pointIsOnLine(_ point: Vector) -> Bool {
        let lineDot = start.x * -end.y + start.y * end.x
        let dot = start.x * -point.y + start.y * point.x
        
        if (lineDot > 0 && dot > 0) {
            return true
        } else if (lineDot < 0 && dot < 0) {
            return true
        } else {
            return false
        }
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
        let baseDelta = end - start//Vector.sub(end, start)
        baseDelta.normalize()
        let normal = Vector(-baseDelta.y, baseDelta.x)

        return normal
    }
    
    public func angle() -> Radians {
        end.angleBetween(start)
    }
    

    /// Find any intersecting points with the specified line
    ///
    /// Adapted from https://stackoverflow.com/a/1968345
    /// - Parameter line: Other line to intersect
    public func lineIntersection(_ line: Line) -> [Vector] {
        // p0 -> self.start
        // p1 -> self.end
        // p2 -> line.start
        // p3 -> line.end
        let s1_x = self.end.x - self.start.x
        let s1_y = self.end.y - self.start.y
        let s2_x = line.end.x - line.start.x
        let s2_y = line.end.y - line.start.y
        
        let s = (-s1_y * (self.start.x - line.start.x) + s1_x * (self.start.y - line.start.y)) / (-s2_x * s1_y + s1_x * s2_y)
        let t = ( s2_x * (self.start.y - line.start.y) - s2_y * (self.start.x - line.start.x)) / (-s2_x * s1_y + s1_x * s2_y)
        
        var intersections = [Vector]()
        if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
            // Collision detected
            let i_x = self.start.x + (t * s1_x)
            let i_y = self.start.y + (t * s1_y)
            
            intersections.append(Vector(i_x, i_y))

        }

        return intersections
    }
    
    /// Calculate the intersection point of a ray and a plane defined by the Line
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    /// - Returns: The point of intersection, if the ray intersections the plane
    public func rayPlaneIntersection(origin: Vector, dir: Vector) -> Vector? {
        let denom = normal().dot(dir)

        let p0 = center - origin
        let t = p0.dot(normal()) / denom
        
        guard t >= 0 else { return nil }
        let pHit = origin + (dir * t)

        // FIXME: A point is returned when ray is parallel to line
        return pHit

    }
    
    /// Calculate the intersection point of a ray and the Line
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the ray
    /// - Returns: The point of intersection, if the ray intersections the line
    public func rayIntersection(origin: Vector, dir: Vector) -> Vector? {

        let v1 = origin - start
        let v2 = end - start
        let v3 = Vector(-dir.y, dir.x)
        
        let dot = v2.dot(v3)
        
        let t1 = Vector.crossProduct(v2, v1) / dot
        let t2 = v1.dot(v3) / dot

        if (t1 >= 0.0 && (t2 >= 0.0 && t2 <= 1.0)) {
            return origin + (dir * t1)
        }
        return nil
    }
    
    /// Return a point at the specified distance of the line
    /// - Parameter distance: Distance from the end point
    public func pointAlongLine(at distance: Double) -> Vector {
        let v = end - start //Vector.sub(end, start)
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
        let element = XMLElement(kind: .element)
        element.name = "line"
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
    public var description: String {
        "Line (\(start.x), \(start.y)) → (\(end.x), \(end.y))"
    }
}

extension Line: Equatable {
    public static func == (lhs: Line, rhs: Line) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
    
    
}
