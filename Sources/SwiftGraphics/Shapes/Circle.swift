//
//  Circle.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle, with an origin and a radius
public class Circle: Polygon, Intersectable {
    
    /// Radius of the circle
    public var radius: Double
    
    /// Center point of the circle
    public var center: Vector
    
    // The offset radius, used when calculating intersections with the circle
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
        self.center = Vector(x: 0, y: 0)
        self.radius = radius

        self.center = Vector(x: x, y: y)
        
        
    }
    
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

        return Vector(x: x, y: y)
    }
    
    /// Return the intersection of a ray
    ///
    /// From https://math.stackexchange.com/a/311956
    /// - Parameters:
    ///   - origin: Origin of the ray
    ///   - dir: Direction of the way
    public func rayIntersection(origin: Vector, dir: Vector) -> Vector? {

        let a = (dir.x - origin.x).squared() + (dir.y - origin.y).squared()
        let b = 2 * (dir.x - origin.x) * (origin.x - center.x) + 2 * (dir.y - origin.y) * (origin.y - center.y)
        let c = (origin.x - center.x).squared() + (origin.y - center.y).squared() - radius.squared()
        
        let discr = b.squared() - 4 * a * c
        
        let t = (2 * c) / (-b + sqrt(discr))
        
        // If t is less than 0 the intersection is behind the ray
        guard t > 0 else { return nil }
        
        let pHit = Vector(
            (dir.x - origin.x) * t + origin.x,
            (dir.y - origin.y) * t + origin.y
        )
        
        return pHit

    }


    public func rayIntersection(origin: Vector, theta: Radians) -> Vector? {
        let e = Vector(angle: theta)
        e.mult(100)
        e.add(origin)
        
        SwiftGraphicsContext.strokeColor = .blue
        e.debugDraw(in: SwiftGraphicsContext.current as! CGContext)
        
        return rayIntersection(origin: origin, dir: e)

    }
    
    
    /// Determine the points where the specified `Line` intersects the `Circle`
    ///
    /// Adapted from http://paulbourke.net/geometry/circlesphere/
    /// - Parameter line: Intersecting line
    public func lineIntersection(_ line: Line) -> [Vector] {
        
        let a = calculateA(line)
        let b = calculateB(line)
        let c = calculateC(line)

        let i = b * b - 4.0 * a * c
        
        var intersections = [Vector]()
        if (i < 0.0) {
            // no intersections
        } else if (i == 0.0) {
            // one intersection
            // p[0] = 1.0
            // p2 = 1.0
            
            let mu = -b / (2.0 * a)
            
            let p1 = Vector(
                line.start.x + mu * (line.end.x - line.start.x),
                line.start.y + mu * (line.end.y - line.start.y),
                line.start.z + mu * (line.end.z - line.start.z)
            )
            
            if line.pointIsOnLine(p1) {
                intersections.append(p1)
            }
            
        } else if (i > 0.0) {
            // first intersection
            var mu = (-b + sqrt(i)) / (2.0 * a)
            
            let p1 = Vector(
                line.start.x + mu * (line.end.x - line.start.x),
                line.start.y + mu * (line.end.y - line.start.y),
                line.start.z + mu * (line.end.z - line.start.z)
            )
            
            
            if line.pointIsOnLine(p1) {
                intersections.append(p1)
            }
            
            // # second intersection
            mu = (-b - sqrt(i)) / (2.0 * a)
            
            let p2 = Vector(
                line.start.x + mu * (line.end.x - line.start.x),
                line.start.y + mu * (line.end.y - line.start.y),
                line.start.z + mu * (line.end.z - line.start.z)
            )

            
            if line.pointIsOnLine(p2) {
                intersections.append(p2)
            }
            
        }
        
        return intersections
        
    }
    
    private func calculateA(_ line: Line) -> Double {
        //    Math.square(line.end.x - line.start.x) +
        //    Math.square(line.end.y - line.start.y) +
        //    Math.square(line.end.z ?? 0 - line.start.z ?? 0)
        return Math.squared(line.end.x - line.start.x) +
            Math.squared(line.end.y - line.start.y) + Math.squared(line.end.z - line.start.z)

    }

    private func calculateB(_ line: Line) -> Double {
        //    2.0 * (
        //        (line.end.x - line.start.x) *
        //            (line.start.x - center.x) +
        //            (line.end.y - line.start.y) *
        //            (line.start.y - center.y) +
        //            (line.end.z ?? 0 - line.start.z ?? 0) *
        //            (line.start.z ?? 0 - center.z ?? 0)
        //    )
        var b =
            (line.end.x - line.start.x) *
                (line.start.x - center.x) +
                (line.end.y - line.start.y) *
                (line.start.y - center.y) +
                (line.end.z - line.start.z) * (line.start.z - center.z)

        b *= 2

        return b
    }

    private func calculateC(_ line: Line) -> Double {
        //    Math.square(center.x) +
        //        Math.square(center.y) +
        //        Math.square(center.z ?? 0) +
        //        Math.square(line.start.x) +
        //        Math.square(line.start.y) +
        //        Math.square(line.start.z ?? 0) -
        //        2.0 * (
        //            center.x *
        //                line.start.x +
        //                center.y *
        //                line.start.y +
        //                center.z ?? 0 *
        //                line.start.z ?? 0
        //        ) -
        //        Math.square(r)
        //    )

        let part1 = Math.squared(center.x) +
            Math.squared(center.y) +
            Math.squared(line.start.x) +
            Math.squared(line.start.y) +
            center.z.squared() +
            line.start.z.squared()


        let part2 = center.x *
            line.start.x +
            center.y *
            line.start.y +
            center.z * line.start.z

        return part1 - 2 * part2 - offsetRadius.squared()

    }
    
    /// Determine whether teh specified point is inside the circle
    ///
    /// This method compares the distance between the center and point to the radius of the circle.
    /// - Parameter point: Whether the point is inside the circle
    public func contains(_ point: Vector) -> Bool {
        return point.dist(center) < radius
    }
    
//    /// Return an array of points at the specified angular distance apart
//    /// - Parameter angle: Angle in degrees
//    public func pointsDistributed(every angle: Degrees, starting: Degrees = 0, ending: Degrees = 360) -> [Vector] {
//        stride(from: starting, to: ending, by: angle).map { angle in
//            rayIntersection(angle.toRadians())
//        }
//    }
}

extension Circle: CGDrawable {
    /// Draw the circle
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
    
    public func debugDraw(in context: CGContext) {
        draw(in: context)
    }
}

extension Circle: SVGDrawable {
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

