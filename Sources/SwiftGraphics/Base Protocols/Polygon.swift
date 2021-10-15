//
//  Polygon.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Represents a `Shape` that has an internal area
public protocol Polygon: Intersectable {
    
    /// A boolean indicating whether the specified point lies within the shape
    func contains(_ point: Vector) -> Bool

    /// Return the intersection point of the specified angle from the center of the shape
    /// - Parameter angle: The angle
    func point(at angle: Radians) -> Vector
    
    /// The angle of a point relative to the center
    /// - Parameter point: The point to to determine the angle between.
    func angle(ofPoint point: Vector) -> Radians
    
    /// Create a Bézier path representing the shape
    ///
    /// - Parameters:
    ///   - start: Starting angle
    ///   - end: Ending Angle
    /// - Returns: An array of `BezierPath` which draw the shape
    func bezierCurve(start: Radians, end: Radians) -> [BezierPath]
    
}

extension Polygon {
    
    /// Create a grid `Vector`s within the Polygon's bounding box.
    ///
    /// This method strides through the X axis and then the Y, creating columns of points.
    ///
    /// - Parameter stepSize: The distance between each row & column in the grid.
    /// - Parameter limitToShape: Whether to only return points within the shape.
    /// - Returns: An array of `Vector`s.
    public func makeGrid(with stepSize: Double, limitToShape: Bool = true) -> [Vector] {
        var points = [Vector]()
        stride(from: self.boundingBox.minX, through: self.boundingBox.maxX, by: stepSize).forEach { x in
            stride(from: self.boundingBox.minY, through: self.boundingBox.maxY, by: stepSize).forEach { y in
                let point = Vector(x, y)
                if self.contains(point) && limitToShape {
                    points.append(point)
                }
                
            }
        }
        
        return points
    }
    
    /// Perform a Boolean operation between the specified shapes.
    /// - Parameters:
    ///   - shapes: Shapes to operate on
    ///   - operation: The operation to perform
    /// - Returns: An array of the resulting paths
    public func booleanOperation(_ shapes: [Polygon], _ operation: BooleanOperation = .add) -> [BezierPath] {
        
        var shapes = shapes
        shapes.removeAll { $0 === self }

        var intersections = shapes.reduce(into: [Vector]()) { (result, poly) in
            result.append(contentsOf: self.intersections(with: poly))
        }
        
        // Add the rectangle to the intersections
        if case .addIntersecting(let rect) = operation {
            intersections.append(contentsOf: self.intersections(with: rect))
        }
        
//        SwiftGraphicsContext.strokeColor = .blue
//        SwiftGraphicsContext.fillColor = .clear
//        intersections.forEach {
//            $0.debugDraw(in: SwiftGraphicsContext.current as! CGContext) // swiftlint:disable:this force_cast
//        }

        // If there are no intersections, return a full shape
        guard intersections.count >= 2 else {
            return bezierCurve(start: 0, end: Double.twoPi)
        }
        
        var angles: [Radians] = intersections.map {
            angle(ofPoint: $0)
        }
        angles.sort()
        
        if let firstAngle = angles.first, let lastAngle = angles.last {
            if firstAngle < lastAngle {
                angles.append(firstAngle + Double.twoPi)
            } else {
                angles.append(firstAngle)
            }
            
        }
        
        return angles.paired().reduce(into: [BezierPath]()) { (result, arg1) in
            
            let (start, end) = arg1
            
            let halfPoint = self.point(at: (end + start) / 2)
            let inOtherShape = shapes.map { $0.contains(halfPoint) }
            
            switch operation {
            case .addIntersecting(let rect):
                // The half-way point can't be in another shape, but must be inside the rectangle
                guard inOtherShape.allFalse() && rect.contains(halfPoint) else { return }
            case .add:
                guard inOtherShape.allFalse() else { return }
            case .intersect:
                let inOneOther = inOtherShape.reduce(into: false) { (result, contained) in
                    result = result || contained
                }
                
                guard inOneOther else { return }
                
            case .globalIntersect:
                guard inOtherShape.allTrue() else { return }
            }
            
            let arcs: [BezierPath] = bezierCurve(start: start, end: end)
            
            result.append(contentsOf: arcs)
        }
        
    }

}

extension Circle {
    
    /// Create a Bézier arc of the circle between the two points.
    ///
    /// - Parameters:
    ///   - start: Starting angle
    ///   - end: Ending Angle
    /// - Returns: An array of `BezierPath` which draw the shape
    public func bezierCurve(start: Radians, end: Radians) -> [BezierPath] {
        let distance = 90.0.toRadians()
        
        return stride(from: start, to: end, by: distance).map { arcStart in
            
            let size: Radians
            if arcStart + distance < end {
                size = distance
            } else {
                size = end - arcStart
            }
            
            let arc = acuteArc(start: arcStart, size: size)
            return arc
            
        }
    }
}

extension Rectangle {
    
    /// Create a Bézier path of the rectangle between the two points.
    ///
    /// This method returns a single `BezierPath` which draws lines from the start to
    /// end, passing through each corner.
    ///
    /// - Parameters:
    ///   - start: Starting angle
    ///   - end: Ending Angle
    /// - Returns: An array of `BezierPath` which draw the shape
    public func bezierCurve(start: Radians, end: Radians) -> [BezierPath] {

        var corners = [
            angle(ofPoint: topLeft),
            angle(ofPoint: topRight),
            angle(ofPoint: bottomRight),
            angle(ofPoint: bottomLeft),
        ]

        corners = corners.map { angle in
            var angle = angle
            // Ensure angles are positive rotation from 0
            if angle < 0 {
                angle += Radians.twoPi
            }
            
            // Offset the angle
            angle -= start
            
            // If the offset angle wrapped past 360
            if angle > Radians.twoPi {
                angle -= Radians.twoPi
            }
            return angle
        }

        // Filter out angles not between the start and end points
        let newAngles = corners.filter { (angle) -> Bool in
            angle > 0 && angle < end - start
        }

        // Remove offset & add the starting and ending points
        corners = newAngles.map { $0 + start }
        corners.append(start)
        corners.append(end)
        
        // Sort the corners
        corners.sort()
        
        // Create a Bézier from the angles
        let bezier1 = BezierPath(start: point(at: start))
        bezier1.points = corners.map { BezierPath.Point(point: point(at: $0)) }
        
        return [bezier1]
    }
}

/// Geometric Boolean Operations
public enum BooleanOperation {
    
    /// Add the shapes together
    case add
    
    /// Add the shapes together, but intersecting the specified rectangle
    case addIntersecting(Rectangle)
    
    /// Intersect the shapes
    case intersect
    
    /// Globally intersect the shapes
    case globalIntersect
    
}

public extension Array where Element: Polygon {
    
    /// Determine whether the specified point is contained by any Polygon.
    /// - Parameter point: The point to test
    /// - Returns: A Boolean indicating whether the point is contained by any Polygon.
    func contains(_ point: Vector) -> Bool {
        self.reduce(into: false) { result, circle in
            result = result && circle.contains(point)
        }
    }
    
    /// Return the Polygon that contains the specified point
    /// - Parameter point: The point to test
    /// - Returns: The Polygon containing the point
    func shapeContaining(point: Vector) -> Polygon? {
        self.reduce(into: nil) { (result, shape) in
            if shape.contains(point) {
                result = shape
            }
        }
    }
}
