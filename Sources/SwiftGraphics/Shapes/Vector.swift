//
//  Point.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Represents a Euclidean vector
public class Vector: Shape {
    
    /// The `x` position of the vector
    public var x: Double
    
    /// The `y` position of the vector
    public var y: Double
    
    /// The `z` position of the vector
    public var z: Double
    
    /// Instantiate a new `Vector` at the specified coordinates
    /// - Parameters:
    ///   - x: The `x` position of the vector
    ///   - y: The `y` position of the vector
    ///   - z: The `z` position of the vector
    public init(x: Double, y: Double, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /// Instantiate a new `Vector` at the specified coordinates
    /// - Parameters:
    ///   - x: The `x` position of the vector
    ///   - y: The `y` position of the vector
    ///   - z: The `z` position of the vector
    public init(_ x: Double, _ y: Double, _ z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /// Instantiate a new `Vector` at the specified coordinates
    /// - Parameters:
    ///   - x: The `x` position of the vector
    ///   - y: The `y` position of the vector
    ///   - z: The `z` position of the vector
    public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat = 0) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }
    
    /// Instantiate a new `Vector` with the specified angle
    /// - Parameter angle: The angle, in Radians, of the vector
    public init(angle: Radians) {
        self.x = cos(angle)
        self.y = sin(angle)
        self.z = 0
    }
    
    
    /// Set the coordinates of the receiver to those of the specified vector
    /// - Parameter v: The vector whose coordinates will be copied
    public func set(_ v: Vector) {
        self.x = v.x
        self.y = v.y
        self.z = v.z
    }
    
    /// Return a new instance of the receiver
    public func copy() -> Vector {
        return Vector(self.x, self.y, self.z)
    }
    
    
    /// Return a `CGPoint` of the receiver
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
    
    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        Rectangle(x: x, y: y, width: 1, height: 1)
    }
    
    /// Return an `NSPoint` of the receiver
    public func nsPoint() -> NSPoint {
        NSPoint(x: x, y: y)
    }
    
}

// MARK: - Static Vector Math Functions
extension Vector {
    
    
    /// Add two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    @available(*, unavailable, message: "Use +")
    public static func add(_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(
            v1.x + v2.x,
            v1.y + v2.y,
            v1.z + v2.z
        )
    }
    
    /// Subtract the second `Vector` from the first
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    @available(*, unavailable, message: "Use -")
    public static func sub (_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
    }
    
    /// Multiply two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    @available(*, unavailable, message: "Use *")
    public static func mult(_ v: Vector, _ n: Double) -> Vector {
        return Vector(v.x * n, v.y * n, v.z * n)
    }
    
    /// Divide the specified `Vector` by a constant
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    @available(*, unavailable, message: "Use /")
    public static func div(_ v: Vector, _ n: Double) -> Vector {
        return Vector(v.x / n, v.y / n, v.z / n)
    }
    
    /// Return the distance between two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    public static func dist(_ v1: Vector, _ v2: Vector) -> Double {
        return sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2) + pow(v2.z - v1.z, 2))
    }
    
    /// Return the dot product of two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    public static func dot(_ v1: Vector, _ v2: Vector) -> Double {
        return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
    }
    
    /// Return the cross product of two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    public static func cross(_ v1: Vector, _ v2: Vector) -> Vector {

        let x = v1.y * v2.z - v1.z * v2.y
        let y = v1.z * v2.x - v1.x * v2.z
        let z = v1.x * v2.y - v1.y * v2.x
        
        return Vector(x, y, z)
    }
    
    /// Calculates the cross product of two vectors.
    ///
    /// The following formula is used to calculate the cross product:
    ///
    /// `(Vector1.X * Vector2.Y) - (Vector1.Y * Vector2.X)`
    ///
    ///  [Implementation][] from C#.
    ///
    /// [Implementation]: https://docs.microsoft.com/en-us/dotnet/api/system.windows.vector.crossproduct?view=netcore-3.1
    ///
    /// - Parameters:
    ///   - v1: The first vector to evaluate.
    ///   - v2: The second vector to evaluate.
    /// - Returns: The cross product of vector1 and vector2.
    public static func crossProduct(_ v1: Vector, _ v2: Vector) -> Double {
        // (Vector1.X * Vector2.Y) - (Vector1.Y * Vector2.X)
        return (v1.x * v2.y) - (v1.y * v2.x)
    }
    
}

// MARK: - Vector Math Functions
extension Vector {
    
    public func mag() -> Double {
        return sqrt(self.magSq())
    }
    
    public func magSq() -> Double {
        return x * x + y * y + z * z
    }
    
    public func dist(_ v: Vector) -> Double {
        return Vector.dist(v, self)
    }
    
    public func dot(_ v: Vector) -> Double {
        return Vector.dot(self, v)
    }
    
    public func cross(_ v: Vector) -> Vector {
        return Vector.cross(self, v)
    }
    
    public func normalize() {
        let len = self.mag()
        if (len != 0) {
            self *= 1 / len
        }
    }

    public func angleBetween(_ v: Vector) -> Double {
        let dotmagmag = self.dot(v) / (self.mag() * v.mag())
        // Mathematically speaking: the dotmagmag variable will be between -1 and 1
        // inclusive. Practically though it could be slightly outside this range due
        // to floating-point rounding issues. This can make Math.acos return NaN.
        //
        // Solution: we'll clamp the value to the -1,1 range
        
        var angle = acos(min(1, max(-1, dotmagmag)))
        angle = angle * sign(self.cross(v).z)
        
        return angle
        
    }
    
    func sign(_ num: Double) -> Double {
        return num >= 0 ? 1 : -1
    }
    
    /// Provide the heading of the receiver
    public func heading() -> Radians {
        return atan2(self.y, self.x)
    }
    
    
    /// Rotate the receiver by the specified angle
    /// - Parameter theta: Angle, in radians, to rotate
    public func rotate(by theta: Radians) {
        let newHeading = self.heading() + theta
        rotate(to: newHeading)
        
    }
    
    /// Set the heading of the receiver to the specified angle
    /// - Parameter theta: The new heading
    public func rotate(to theta: Radians) {
        let newHeading = theta
        
        self.x = cos(newHeading) * mag()
        self.y = sin(newHeading) * mag()
        
    }
}

extension Vector: CGDrawable {
    
    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {
        Rectangle(x: x, y: y, width: 1, height: 1).draw(in: context)
    }
    
    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        Circle(center: self, radius: 5).draw(in: context)
    }
}


extension Vector: SVGDrawable {
    
    /// Create a `XMLElement` representing the receiver
    public func svgElement() -> XMLElement {
        let rect = Rectangle(x: x, y: y, width: 1, height: 1).svgElement()
        rect.addAttribute("vector", forKey: "class")
        
        return rect
    }
}

extension Vector: CustomStringConvertible {
    public var description: String {
        "Vector (\(x), \(y))"
    }
}

extension Vector {
    public static func + (lhs: Vector, rhs: Vector) -> Vector {
        Vector(
            lhs.x + rhs.x,
            lhs.y + rhs.y,
            lhs.z + rhs.z
        )
    }
    
    public static func += (lhs: Vector, rhs: Vector) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    public static func - (lhs: Vector, rhs: Vector) -> Vector {
        Vector(
            lhs.x - rhs.x,
            lhs.y - rhs.y,
            lhs.z - rhs.z
        )
    }
    
    public static func -= (lhs: Vector, rhs: Vector) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
    
    public static func * (lhs: Vector, n: Double) -> Vector {
        Vector(lhs.x * n, lhs.y * n, lhs.z * n)
    }
    
    public static func *= (lhs: Vector, n: Double) {
        lhs.x *= n
        lhs.y *= n
        lhs.z *= n
    }
    
    public static func / (lhs: Vector, n: Double) -> Vector {
        Vector(lhs.x / n, lhs.y / n, lhs.z / n)
    }
    
    public static func /= (lhs: Vector, n: Double) {
        lhs.x /= n
        lhs.y /= n
        lhs.z /= n
    }
    
    public static prefix func - (vector: Vector) -> Vector {
        return Vector(-vector.x, -vector.y, -vector.z)
    }
}

extension Vector: Equatable {
    public static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    
}
