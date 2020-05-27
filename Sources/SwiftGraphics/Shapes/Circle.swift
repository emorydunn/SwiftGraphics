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
        
//        return rayIntersection(origin: center, theta: theta)!
        let x = center.x + radius * cos(theta)
        let y = center.y + radius * sin(theta)

        return Vector(x: x, y: y)
    }
    
    public func rayIntersection(origin: Vector, dir: Vector) -> Vector? {

        
        
//
        let l = Vector.sub(origin, center)
        let a = dir.dot(dir)
        let b = 2 * dir.dot(l)
        let c = l.dot(l) - radius * 2
//
        guard var (t0, t1) = solveQuadratic(a: a, b: b, c: c) else {
            print("solveQuadratic failed")
            return nil
        }

        
        if t0 > t1 {
            swap(&t0, &t1)
        }

        if t0 < 0 {
            t0 = t1 // if t0 is negative, let's use t1 instead
            if t0 < 0 {
                print("t0 is less than 0 after swapping with t1")
                return nil

            }
        }

        let t = t0
        let v = Vector.add(origin, dir)
        v.mult(t)

        SwiftGraphicsContext.strokeColor = .red
        v.debugDraw(in: SwiftGraphicsContext.current as! CGContext)

        return v
        
    }
    
    public func analyticIntersection(origin: Vector, dir: Vector) -> Vector? {
        let origin = origin.copy()
        dir.normalize()
        
        let l = Vector.sub(origin, center)
        let a = dir.dot(dir)
        let b = 2 * dir.dot(l)
        let c = l.dot(l) - radius * 2

        guard let (t0, t1) = solveQuadratic(a: a, b: b, c: c) else {
            print("solveQuadratic failed")
            return nil
        }
        
        // Intersection Point determination
        return resolveTValues(origin: origin, dir: dir, t0: t0, t1: t1)

        
    }
//
//    public func analyticIntersectionII(origin: Vector, dir: Vector) -> Vector? {
//
////        let origin = origin.copy()
////
////        let l = Vector.sub(origin, center)
////        let a = dir.dot(dir)
////        let b = 2 * dir.dot(l)
////        let c = l.dot(l) - radius * 2
////
////        guard let (t0, t1) = solveQuadratic(a: a, b: b, c: c) else {
////            print("solveQuadratic failed")
////            return nil
////        }
////
////        // Intersection Point determination
////        return resolveTValues(origin: origin, dir: dir, t0: t0, t1: t1)
////
//
//    }
    
    public func geometricIntersection(origin: Vector, dir: Vector) -> Vector? {
        let origin = origin.copy()
        
        // geometric solution
        let l = Vector.sub(center, origin)
        let tca = l.dot(dir)
        guard tca > 0 else {
            print("tca < 0")
            return nil
        }
        
        let d2 = l.dot(l) - tca * tca
        let radius2 = radius.squared()
        
        guard d2 < radius2 else {
            print("d2 > radius:", d2, radius2, d2 > radius2)
            return nil
        }
        
        let thc = sqrt(radius2 - d2)
        
        let t0 = tca - thc
        let t1 = tca + thc
        
        
        // Intersection Point determination
        return resolveTValues(origin: origin, dir: dir, t0: t0, t1: t1)

        
    }
    
    func resolveTValues(origin: Vector, dir: Vector, t0: Double, t1: Double) -> Vector? {
        var t0 = t0
        var t1 = t1
        
        print(t0, t1)
        
        if t0 > t1 {
            print("Swapping t values")
            swap(&t0, &t1)
        }
        
        if t0 < 0 {
            print("Using t1")
            t0 = t1 // if t0 is negative, let's use t1 instead
//            guard t0 > 0 else {
//                print("both t0 and t1 are negative")
//                return nil
//            }
        }
        
        let t = t0
        let pHit = Vector(
            origin.x + dir.x * t,
            origin.y + dir.y * t
        )
//        pHit.sub(center)

        SwiftGraphicsContext.strokeColor = .red
        pHit.debugDraw(in: SwiftGraphicsContext.current as! CGContext)
        
        return pHit
    }
    
    public func geometricIntersectionII(origin: Vector, dir: Vector) -> Vector? {
        let e = dir.copy()
        e.normalize()
        let h = Vector.sub(center, origin)
        let lf = e.dot(h)
        var s = radius.squared() - h.dot(h) + lf.squared()
        
        guard s > 0 else { return nil }
        
        s = sqrt(s)
        
        var resultCount = 0
        
        if lf < s {
            if lf + s >= 0 {
                s = -s
                resultCount = 1
            }
        } else {
            resultCount = 2
        }
        
        print("Result count: \(resultCount)")
        
        let pHit = Vector.mult(e, lf - s)
        pHit.add(origin)
        
        SwiftGraphicsContext.strokeColor = .red
        pHit.debugDraw(in: SwiftGraphicsContext.current as! CGContext)
        
        return pHit
    }

    public func rayIntersection(origin: Vector, theta: Radians) -> Vector? {
        let e = Vector(angle: theta)
        e.mult(100)
        e.add(origin)
        
        SwiftGraphicsContext.strokeColor = .blue
        e.debugDraw(in: SwiftGraphicsContext.current as! CGContext)
        e.normalize()
        
        
        
        let l = Vector.sub(center, origin)
//        let a = e.dot(e)
//        let b = 2 * e.dot(l)
//        let c = l.dot(l) - radius * 2
//
//        guard var (t0, t1) = solveQuadratic(a: a, b: b, c: c) else {
//            print("solveQuadratic failed")
//            return nil
//        }
        
        let tca = l.dot(e)
        let d2 = l.dot(l) - tca * tca

        guard d2 < pow(radius, 2) else {
            print("d2 > radius ^ 2", d2, pow(radius, 2))
            return nil
            
        }

        let thc = sqrt(pow(radius, 2) - d2)
        var t0 = tca - thc
        var t1 = tca + thc
        
        
        
        if t0 > t1 {
            swap(&t0, &t1)
        }
        
        if t0 < 0 {
            t0 = t1 // if t0 is negative, let's use t1 instead
            if t0 < 0 {
                print("t0 is less than 0 after swapping with t1")
                return nil
                
            }
        }
        
        let t = t0
        let v = Vector.add(origin, e)
        v.mult(t)

        SwiftGraphicsContext.strokeColor = .red
        v.debugDraw(in: SwiftGraphicsContext.current as! CGContext)

        return v

    }
    
    func solveQuadratic(a: Double, b: Double, c: Double) -> (Double, Double)? {
        let discr = b * b - 4 * a * c
        
        var x0: Double
        var x1: Double
        
        if discr < 0 {
            print("discr < 0:", discr)
            return nil
        } else if discr == 0 {
            x0 = -0.5 * b / a
            x1 = x0
        } else {
            let q = b > 0 ? -0.5 * (b + sqrt(discr)) : -0.5 * (b - sqrt(discr))
            x0 = q / a
            x1 = c / q
        }

        return (x0, x1)
    }
    
//    func swa
    
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
//        }

//        return a

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

//        if let startZ = line.start.z, let endZ = line.end.z, let centerZ = center.z {
//            b += (line.end.z - line.start.z) * (line.start.z - centerZ.z)
//        }

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

