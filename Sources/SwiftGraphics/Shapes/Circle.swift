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
    
    /// Color of the outline of the shape
    public var strokeColor: CGColor = .black
    
    /// Color of the fill of the shape
    public var fillColor: CGColor = .clear
    
    /// Weight of the outline of the shape
    public var strokeWeight: Double = 1
    
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
        
//        if x == nil && y == nil {
//            guard let contextWidth = context?.width, let contextHeight = context?.height else {
//                return
//            }
//            self.center = Vector(x: Double(contextWidth / 4),
//                  y: Double(contextHeight / 4))
//            
//        } else if let x = x, let y = y {
//            
//        }
        self.center = Vector(x: x, y: y)
        
        
    }
    
    /// Return the intersection point of the specified angle from the center of the circle
    /// - Parameter angle:The angle
    public func pointOnCircle(_ angle: Radians) -> Vector {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        return Vector(x: x, y: y)
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
                line.start.y + mu * (line.end.y - line.start.y)
            )
            if let startZ = line.start.z, let endZ = line.end.z {
                p1.z = startZ + mu * (endZ - startZ)
            }
            if line.pointIsOnLine(p1) {
                intersections.append(p1)
            }
            
        } else if (i > 0.0) {
            // first intersection
            var mu = (-b + sqrt(i)) / (2.0 * a)
            
            let p1 = Vector(
                line.start.x + mu * (line.end.x - line.start.x),
                line.start.y + mu * (line.end.y - line.start.y)
            )
            if let startZ = line.start.z, let endZ = line.end.z {
                p1.z = startZ + mu * (endZ - startZ)
            }
            
            if line.pointIsOnLine(p1) {
                intersections.append(p1)
            }
            
            // # second intersection
            mu = (-b - sqrt(i)) / (2.0 * a)
            
            let p2 = Vector(
                line.start.x + mu * (line.end.x - line.start.x),
                line.start.y + mu * (line.end.y - line.start.y)
            )
            if let startZ = line.start.z, let endZ = line.end.z {
                p1.z = startZ + mu * (endZ - startZ)
            }
            
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
        var a = Math.squared(line.end.x - line.start.x) +
            Math.squared(line.end.y - line.start.y)

        if let startZ = line.start.z, let endZ = line.end.z {
            a += Math.squared(endZ - startZ)
        }

        return a

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
                (line.start.y - center.y)

        if let startZ = line.start.z, let endZ = line.end.z, let centerZ = center.z {
            b += (endZ - startZ) * (startZ - centerZ)
        }

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

        var part1 = Math.squared(center.x) +
            Math.squared(center.y) +
            Math.squared(line.start.x) +
            Math.squared(line.start.y)

        if let startZ = line.start.z, let centerZ = center.z {
            part1 += centerZ.squared()
            part1 += startZ.squared()

        }

        var part2 = center.x *
            line.start.x +
            center.y *
            line.start.y
        if let startZ = line.start.z, let centerZ = center.z {
            part2 += centerZ * startZ
        }

        return part1 - 2 * part2 - offsetRadius.squared()

    }
    
    /// Determine whether teh specified point is inside the circle
    ///
    /// This method compares the distance between the center and point to the radius of the circle.
    /// - Parameter point: Whether the point is inside the circle
    public func contains(_ point: Vector) -> Bool {
        return point.dist(center) < radius
    }
}

extension Circle: CGDrawable {
    /// Draw the circle
    public func draw(in context: CGContext) {
        
        context.saveGState()
        context.translateBy(x: CGFloat(-radius), y: CGFloat(-radius))
        let bb = CGRect(x: center.x, y: center.y, width: diameter, height: diameter)
        
        context.setStrokeColor(strokeColor)
        context.setFillColor(fillColor)
        context.setLineWidth(CGFloat(strokeWeight))
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
        element.setAttributesWith([
            "cx": String(self.center.x),
            "cy": String(self.center.y),
            "r": String(self.radius),
            "stroke": strokeColor.toHex(),
            "fill": fillColor.toHex(),
            "stroke-width": String(strokeWeight)
        ])
        
        
        return element
    }
}
