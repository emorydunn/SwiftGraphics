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
    public func set(_ vector: Vector) {
        self.x = vector.x
        self.y = vector.y
        self.z = vector.z
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
    
    /// Return the distance between two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    public static func dist(_ lhs: Vector, _ rhs: Vector) -> Double {
        return sqrt(pow(rhs.x - lhs.x, 2) + pow(rhs.y - lhs.y, 2) + pow(rhs.z - lhs.z, 2))
    }

    /// Return the dot product of two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    public static func dot(_ lhs: Vector, _ rhs: Vector) -> Double {
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }

    /// Return the cross product of two `Vector`s
    /// - Parameters:
    ///   - v1: The first `Vector`
    ///   - v2: the second `Vector`
    public static func cross(_ lhs: Vector, _ rhs: Vector) -> Vector {

        let x = lhs.y * rhs.z - lhs.z * rhs.y
        let y = lhs.z * rhs.x - lhs.x * rhs.z
        let z = lhs.x * rhs.y - lhs.y * rhs.x

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
    /// [Implementation]: https://docs.microsoft.com/en-us/dotnet/api/system.windows.vector.crossproduct
    ///
    /// - Parameters:
    ///   - v1: The first vector to evaluate.
    ///   - v2: The second vector to evaluate.
    /// - Returns: The cross product of vector1 and vector2.
    public static func crossProduct(_ lhs: Vector, _ rhs: Vector) -> Double {
        // (Vector1.X * Vector2.Y) - (Vector1.Y * Vector2.X)
        return (lhs.x * rhs.y) - (lhs.y * rhs.x)
    }

}

// MARK: - Vector Math Functions
extension Vector {
    
    /// Calculates the magnitude (length) of the vector and returns the result as a float
    ///
    /// This is simply the equation `sqrt(x*x + y*y + z*z)`.
    public func mag() -> Double {
        return sqrt(self.magSq())
    }
    
    /// Calculates the squared magnitude of the vector and returns the result as a float
    ///
    /// This is simply the equation `(x*x + y*y + z*z)`.
    ///
    /// - Note: Faster if the real length is not required in the case of comparing vectors, etc.
    public func magSq() -> Double {
        return x * x + y * y + z * z
    }
    
    /// Return the distance to another vector
    /// - Parameter vector: Another vector
    /// - Returns: Distance to the second vector
    public func dist(_ vector: Vector) -> Double {
        return Vector.dist(vector, self)
    }

    /// Calculates the dot product of two vectors.
    public func dot(_ vector: Vector) -> Double {
        return Vector.dot(self, vector)
    }

    /// Calculates and returns a vector composed of the cross product between two vectors
    public func cross(_ vector: Vector) -> Vector {
        return Vector.cross(self, vector)
    }
    
    /// Normalize the vector to length 1 (make it a unit vector).
    public func normalize() {
        let len = self.mag()
        if len != 0 {
            self *= 1 / len
        }
    }
    
    /// Calculates and returns the angle (in radians) between two vectors.
    public func angleBetween(_ vector: Vector) -> Double {
        let dotmagmag = self.dot(vector) / (self.mag() * vector.mag())
        // Mathematically speaking: the dotmagmag variable will be between -1 and 1
        // inclusive. Practically though it could be slightly outside this range due
        // to floating-point rounding issues. This can make Math.acos return NaN.
        //
        // Solution: we'll clamp the value to the -1,1 range

        var angle = acos(min(1, max(-1, dotmagmag)))
        angle *= sign(self.cross(vector).z)

        return angle

    }

    private func sign(_ num: Double) -> Double {
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
    /// A textual representation of this instance.
    public var description: String {
        "Vector (\(x), \(y))"
    }
}

extension Vector {
    
    /// Adds two values and produces their sum.
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func + (lhs: Vector, rhs: Vector) -> Vector {
        Vector(
            lhs.x + rhs.x,
            lhs.y + rhs.y,
            lhs.z + rhs.z
        )
    }
    
    /// Adds two values and stores the result in the left-hand-side variable
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func += (lhs: Vector, rhs: Vector) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    
    /// Add the specified value to a vector
    ///
    /// - Parameters:
    ///   - vector: The first value to add.
    ///   - num: The second value to add.
    public static func + (vector: Vector, num: Double) -> Vector {
        Vector(
            vector.x + num,
            vector.y + num,
            vector.z + num
        )
    }

    /// Add the specified value to a vector
    ///
    /// - Parameters:
    ///   - vector: The first value to add.
    ///   - num: The second value to add.
    public static func += (vector: Vector, num: Double) {
        vector.x += num
        vector.y += num
        vector.z += num
    }

    /// Subtracts one vector from another and produces their difference
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    public static func - (lhs: Vector, rhs: Vector) -> Vector {
        Vector(
            lhs.x - rhs.x,
            lhs.y - rhs.y,
            lhs.z - rhs.z
        )
    }

    /// Subtracts the second vector from the first and stores the difference in the left-hand-side variable
    ///
    /// - Parameters:
    ///   - lhs: The first vector to subtract.
    ///   - rhs: The second vector to subtract.
    public static func -= (lhs: Vector, rhs: Vector) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }

    /// Subtracts one value from another and produces their difference, rounded to a representable value.
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    public static func - (vector: Vector, num: Double) -> Vector {
        Vector(
            vector.x - num,
            vector.y - num,
            vector.z - num
        )
    }
    
    /// Subtracts the second value from the first and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    public static func -= (vector: Vector, num: Double) {
        vector.x -= num
        vector.y -= num
        vector.z -= num
    }
    
    /// Multiplies two values and produces their product
    ///
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func * (lhs: Vector, num: Double) -> Vector {
        Vector(lhs.x * num, lhs.y * num, lhs.z * num)
    }
    
    /// Multiplies two values and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func *= (lhs: Vector, num: Double) {
        lhs.x *= num
        lhs.y *= num
        lhs.z *= num
    }
    
    /// Multiplies two values and produces their product
    ///
    /// Multiplying two `Vector`s calculates the dot product.
    ///
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func * (lhs: Vector, rhs: Vector) -> Double {
        lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
    }
    
    /// Returns the quotient of dividing the first value by the second.
    /// - Parameters:
    ///   - lhs: The value to divide.
    ///   - num: The value to divide lhs by.
    public static func / (lhs: Vector, num: Double) -> Vector {
        Vector(lhs.x / num, lhs.y / num, lhs.z / num)
    }
    
    /// Divides the first value by the second and stores the quotient in the left-hand-side variable.
    /// - Parameters:
    ///   - lhs: The value to divide.
    ///   - num: The value to divide lhs by.
    public static func /= (lhs: Vector, num: Double) {
        lhs.x /= num
        lhs.y /= num
        lhs.z /= num
    }

    /// Returns the quotient of dividing the first value by the second.
    /// - Parameters:
    ///   - lhs: The value to divide.
    ///   - num: The value to divide lhs by.
    public static func / (num: Double, vector: Vector) -> Vector {
        Vector(num / vector.x, num / vector.y, num / vector.z)
    }
    
    /// Negate a Vector.
    ///
    /// - Parameter vector: The vector to negate
    public static prefix func - (vector: Vector) -> Vector {
        return Vector(-vector.x, -vector.y, -vector.z)
    }
}

extension Vector: Hashable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values a and b, a == b implies that a != b is false.
    public static func == (lhs: Vector, rhs: Vector) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }

}
