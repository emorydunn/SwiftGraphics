//
//  DefaultIntersections.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 8/1/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation


public extension Line {
    
    /// Calculate points of intersection with another shape.
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersections(with otherShape: Intersectable) -> [Vector] {
        
        switch otherShape {
        case let shape as Line:
            return intersection(with: shape)
        case let shape as Circle:
            return intersection(with: shape)
        case let shape as Rectangle:
            return intersection(with: shape)
        default:
            return []
        }
    }
    
    /// Calculate points of intersection with a `Line`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Line) -> [Vector] {
        return IntersectionMethods.intersections(between: self, and: otherShape)
    }
    
    /// Calculate points of intersection with a `Circle`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Circle) -> [Vector] {
        return IntersectionMethods.intersections(between: self, and: otherShape)
    }
    
    /// Calculate points of intersection with a `Rectangle`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Rectangle) -> [Vector] {
        return IntersectionMethods.intersections(between: self, and: otherShape)
    }
}

public extension Circle {
    
    /// Calculate points of intersection with another shape.
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersections(with otherShape: Intersectable) -> [Vector] {
        
        switch otherShape {
        case let shape as Line:
            return intersection(with: shape)
        case let shape as Circle:
            return intersection(with: shape)
        case let shape as Rectangle:
            return intersection(with: shape)
        default:
            return []
        }
    }
    
    /// Calculate points of intersection with a `Line`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Line) -> [Vector] {
        return IntersectionMethods.intersections(between: otherShape, and: self)
    }
    
    /// Calculate points of intersection with a `Circle`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Circle) -> [Vector] {
        return IntersectionMethods.intersections(between: self, and: otherShape)
    }
    
    /// Calculate points of intersection with a `Rectangle`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Rectangle) -> [Vector] {
        return IntersectionMethods.intersections(between: self, and: otherShape)
    }
}

public extension Rectangle {
    
    /// Calculate points of intersection with another shape.
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersections(with otherShape: Intersectable) -> [Vector] {
        
        switch otherShape {
        case let shape as Line:
            return intersection(with: shape)
        case let shape as Circle:
            return intersection(with: shape)
        case let shape as Rectangle:
            return intersection(with: shape)
        default:
            return []
        }
    }
    
    /// Calculate points of intersection with a `Line`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Line) -> [Vector] {
        return IntersectionMethods.intersections(between: otherShape, and: self)
    }
    
    /// Calculate points of intersection with a `Circle`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Circle) -> [Vector] {
        return IntersectionMethods.intersections(between: otherShape, and: self)
    }
    
    /// Calculate points of intersection with a `Rectangle`
    /// - Parameter otherShape: The shape with which to find intersection points
    /// - Returns: An array of Vectors
    func intersection(with otherShape: Rectangle) -> [Vector] {
        return IntersectionMethods.intersections(between: self, and: otherShape)
    }
}


/// A wrapper around intersection logic between all `Intersectable` shapes
enum IntersectionMethods {
    
     // MARK: - Line Intersections
    
    /// Determine the points where the specified `Line` intersects the `Circle`
    ///
    /// Adapted from the C version by [Paul Bourke](http://paulbourke.net/geometry/circlesphere/).
    /// - Parameters:
    ///   - line: Line to intersect
    ///   - circle: Circle to intersect
    /// - Returns: An array of points at the shape intersections
    static func intersections(between line: Line, and circle: Circle) -> [Vector] {
        let deltaLine = line.end - line.start
        
        let a = deltaLine.magSq()
        let b = 2 * (deltaLine.x * (line.start.x - circle.center.x) +
            deltaLine.y * (line.start.y - circle.center.y) +
            deltaLine.z * (line.start.z - circle.center.z))
        var c = circle.center.magSq()
        
        c += line.start.magSq()
        c -= 2 * (line.start.dot(circle.center))
        c -= circle.radius.squared()
        
        let bb4ac = b * b - 4 * a * c
        
        let eps: Double = 0.00001
        
        guard abs(a) > eps || bb4ac > 0  else {
            return []
        }
        
        var points = [Vector]()
        
        let mu1 = (-b + sqrt(bb4ac)) / (2 * a)
        if mu1 > 0 && mu1 < 1 {
            points.append(line.start + deltaLine * mu1)
        }
        
        let mu2 = (-b - sqrt(bb4ac)) / (2 * a)
        if mu2 > 0 && mu2 < 1 {
            points.append(line.start + deltaLine * mu2)
        }
        
        return points
        
    }
    
    /// Determine the points where the specified `Line` intersects the `Rectangle`
    ///
    /// The rectangle tests whether the line intersects with each of its four edges
    /// - Parameters:
    ///   - line: Line to intersect
    ///   - rect: Rectangle to intersect
    /// - Returns: An array of points at the shape intersections
    static func intersections(between line: Line, and rect: Rectangle) -> [Vector] {
        // Collect the edges
        let edges = [
            rect.topEdge,
            rect.bottomEdge,
            rect.leftEdge,
            rect.rightEdge
        ]
        
        return edges.reduce(into: [Vector]()) { (intersections, edge) in
            intersections.append(contentsOf: IntersectionMethods.intersections(between: line, and: edge))
            
        }
    }
    
    /// Determine the points where the specified `Line` intersects the `Line`
    /// Adapted from https://stackoverflow.com/a/1968345
    /// - Parameters:
    ///   - line: Line to intersect
    ///   - otherLine: Line to intersect
    /// - Returns: An array of points at the shape intersections
    static func intersections(between line: Line, and otherLine: Line) -> [Vector] {
        
        // p0 -> line.start
        // p1 -> line.end
        // p2 -> otherLine.start
        // p3 -> otherLine.end
        let s1X = line.end.x - line.start.x
        let s1Y = line.end.y - line.start.y
        let s2X = otherLine.end.x - otherLine.start.x
        let s2Y = otherLine.end.y - otherLine.start.y
        
        // swiftlint:disable:next identifier_name
        let s = (-s1Y * (line.start.x - otherLine.start.x) + s1X * (line.start.y - otherLine.start.y)) / (-s2X * s1Y + s1X * s2Y)
        // swiftlint:disable:next identifier_name
        let t = ( s2X * (line.start.y - otherLine.start.y) - s2Y * (line.start.x - otherLine.start.x)) / (-s2X * s1Y + s1X * s2Y)
        
        var intersections = [Vector]()
        if s >= 0 && s <= 1 && t >= 0 && t <= 1 {
            // Collision detected
            let intX = line.start.x + (t * s1X)
            let intY = line.start.y + (t * s1Y)
            
            intersections.append(Vector(intX, intY))
            
        }
        
        return intersections
        
    }
    
    // MARK: - Circle Intersections
    //    static func intersections(between circle: Circle, and line: Line) -> [Vector] {
    //        return intersections(between: line, and: circle)
    //    }
    //
    
    /// Determine the points where the specified `Circle` intersects the `Circle`
    ///
    /// Adapted from the C version by [Tim Voght](http://paulbourke.net/geometry/circlesphere/).
    ///
    /// - Parameters:
    ///   - circle: Circle to intersect
    ///   - otherCircle: Other circle to intersect
    /// - Returns: An array of points at the shape intersections
    static func intersections(between circle: Circle, and otherCircle: Circle) -> [Vector] {
        let delta = otherCircle.center - circle.center
        
        // Determine the straight-line distance between the centers.
        // Suggested by Keith Briggs
        let dist = hypot(delta.x, delta.y)
        
        // Check for solvability.
        guard dist < circle.radius + otherCircle.radius else { return [] } // no solution. circles do not intersect.
        
        // no solution. one circle is contained in the other
        guard dist > fabs(circle.radius - otherCircle.radius) else { return [] }
        
        /* 'point 2' is the point where the line through the circle
         * intersection points crosses the line between the circle
         * centers.
         */
        
        // Determine the distance from point 0 to point 2
        let aDist = (circle.radius.squared() - otherCircle.radius.squared() + dist.squared()) / (2.0 * dist)
        
        // Determine the coordinates of point 2
        
        let x2 = circle.center.x + (delta.x * aDist / dist) // swiftlint:disable:this identifier_name
        let y2 = circle.center.y + (delta.y * aDist / dist) // swiftlint:disable:this identifier_name
        
        /* Determine the distance from point 2 to either of the
         * intersection points.
         */
        let hDist = sqrt(circle.radius.squared() - aDist.squared())
        
        /* Now determine the offsets of the intersection points from
         * point 2.
         */
        let rx = -delta.y * (hDist / dist) // swiftlint:disable:this identifier_name
        let ry = delta.x * (hDist / dist) // swiftlint:disable:this identifier_name
        
        /* Determine the absolute intersection points. */
        let xi = x2 + rx // swiftlint:disable:this identifier_name
        let xiPrime = x2 - rx
        let yi = y2 + ry // swiftlint:disable:this identifier_name
        let yiPrime = y2 - ry
        
        let int1 = Vector(xi, yi)
        let int2 = Vector(xiPrime, yiPrime)
        
        return [int1, int2]
    }
    
    /// Determine the points where the specified `Circle` intersects the `Rectangle`
    ///
    /// The rectangle tests whether the line intersects with each of its four edges
    /// - Parameters:
    ///   - line: Circle to intersect
    ///   - rect: Rectangle to intersect
    /// - Returns: An array of points at the shape intersections
    static func intersections(between circle: Circle, and rect: Rectangle) -> [Vector] {
        // Collect the edges
        let edges = [
            rect.topEdge,
            rect.bottomEdge,
            rect.leftEdge,
            rect.rightEdge
        ]
        
        return edges.reduce(into: [Vector]()) { (intersections, edge) in
            intersections.append(contentsOf: IntersectionMethods.intersections(between: edge, and: circle))
        }
    }
    
    // MARK: - Rectangle Intersections
    /// Determine the points where the specified `Circle` intersects the `Rectangle`
    ///
    /// The rectangle tests whether the line intersects with each of its four edges
    /// - Parameters:
    ///   - line: Circle to intersect
    ///   - rect: Rectangle to intersect
    /// - Returns: An array of points at the shape intersections
    static func intersections(between rect: Rectangle, and otherRect: Rectangle) -> [Vector] {
        // Collect the edges
        let edges = [
            otherRect.topEdge,
            otherRect.bottomEdge,
            otherRect.leftEdge,
            otherRect.rightEdge
        ]
        
        return edges.reduce(into: [Vector]()) { (intersections, edge) in
            intersections.append(contentsOf: IntersectionMethods.intersections(between: edge, and: rect))
        }
    }
    
}
