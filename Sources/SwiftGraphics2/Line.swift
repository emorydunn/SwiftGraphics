//
//  Line.swift
//  
//
//  Created by Emory Dunn on 10/13/21.
//

import Foundation

public struct Line {
    
    /// The starting point of the line
    public var start: Vector

    /// The ending point of the line
    public var end: Vector
    
    public var length: Double { end.distance(to: start) }
    
    /// The midpoint of the line
    public var center: Vector {
        Vector(
            (end.x + start.x) / 2,
            (end.y + start.y) / 2
        )
    }
    
    public init(start: Vector, end: Vector) {
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
    ///
    /// From https://gamedev.stackexchange.com/a/57746
    ///
    /// - Parameter point: Whether the point is on the line
    public func contains(_ point: Vector) -> Bool {
        return start + (end - start) * (start.distance(to: point)) / end.distance(to: start) == point
    }
    
    /// Calculate the vector normal of the line
    ///
    /// - Returns: A `Vector` whose heading is perpendicular to the line
    public func normal() -> Vector {
        //calculate base top normal
        let baseDelta = (end - start).normalized()
        let normal = Vector(-baseDelta.y, baseDelta.x)

        return normal
    }
    
    public func slope() -> Double {
        return (end.y - start.y) / (end.x - start.x)
    }

    /// Returns the angle of the line based on the slope
    public func angle() -> Angle {
        return Angle(radians: atan(slope()))
    }
    
    /// Return a point at the specified distance of the line
    /// - Parameter distance: Distance from the end point
    public func point(at distance: Double) -> Vector {
        var v = (end - start).normalized() // swiftlint:disable:this identifier_name
        v *= distance

        return start + v
    }

    ///  Linear interpolate the vector to another vector
    /// - Parameter percent: the amount of interpolation; some value between 0.0 and 1.0
    /// - Returns: A Vector between the original two
    public func lerp(_ percent: Double) -> Vector {
        Vector.lerp(percent: percent, start: start, end: end)
    }

    /// A Rectangle that contains the receiver
//    public var boundingBox: Rectangle {

//        Rectangle(
//        Rectangle(
//            x: min(start.x, end.x),
//            y: min(start.y, end.y),
//            width: abs(end.x - start.x),
//            height: abs(end.y - start.y)
//        )

//    }
}

