//
//  Vector.swift
//  
//
//  Created by Emory Dunn on 10/10/21.
//

import Foundation
import simd


/// A wrapper around a three-dimensional SIMD vector.
public struct Vector {
    var simdVector: simd_double3
    
    public var x: Double {
        get { simdVector.x }
        set { simdVector.x = newValue }
    }
    
    public var y: Double {
        get { simdVector.y }
        set { simdVector.y = newValue }
    }
    
    public var z: Double {
        get { simdVector.z }
        set { simdVector.z = newValue }
    }
    
    /// Instantiate a new `Vector` at the specified coordinates
    /// - Parameters:
    ///   - x: The `x` position of the vector
    ///   - y: The `y` position of the vector
    ///   - z: The `z` position of the vector
    public init(_ x: Double, _ y: Double, _ z: Double = 1) {
        self.simdVector = simd_double3(x: x, y: y, z: z)
    }
    
    /// Create a new `Vector` by applying a transformation to the specified points.
    /// - Parameters:
    ///   - x: The `x` position of the vector
    ///   - y: The `y` position of the vector
    ///   - z: The `z` position of the vector
    public init(_ x: Double, _ y: Double, _ z: Double = 1, transformation: simd_double3x3) {
        self.simdVector = transformation * simd_double3(x: x, y: y, z: z)
    }
    
    init(_ simdVector: simd_double3) {
        self.simdVector = simdVector
    }
}

extension Vector: Equatable, CustomStringConvertible {
    public var description: String {
        "Vector (\(x), \(y), \(z))"
    }
}

// MARK: - Vector Math Functions
public extension Vector {
    
    /// Normalizes the vector
    mutating func normalize() {
        self.simdVector = simd_normalize(simdVector)
    }
    
    /// Returns a vector pointing in the same direction of the supplied vector with a length of 1.
    func normalized() -> Vector {
        Vector(simd_normalize(simdVector))
    }
    
    /// Calculates the magnitude (length) of the vector.
    @available(*, deprecated, renamed: "length()")
    func mag() -> Double {
        simd_length(simdVector)
    }
    
    /// Calculates the magnitude (length) of the vector.
    func length() -> Double {
        simd_length(simdVector)
    }
    
    /// Calculates the squared magnitude of the vector.
    ///
    /// - Note: Faster if the real length is not required in the case of comparing vectors, etc.
    @available(*, deprecated, renamed: "lengthSquared()")
    func magSq() -> Double {
        simd_length_squared(simdVector)
    }
    
    /// Calculates the squared magnitude of the vector.
    ///
    /// - Note: Faster if the real length is not required in the case of comparing vectors, etc.
    func lengthSquared() -> Double {
        simd_length_squared(simdVector)
    }
    
    /// Returns the distance to another vector
    /// - Parameter vector: Another vector
    /// - Returns: Distance to the second vector
    @available(*, deprecated, renamed: "distance(to:)")
    func dist(_ vector: Vector) -> Double {
        simd_distance(simdVector, vector.simdVector)
    }
    
    /// Returns the distance to another vector
    /// - Parameter vector: Another vector
    /// - Returns: Distance to the second vector
    func distance(to vector: Vector) -> Double {
        simd_distance(simdVector, vector.simdVector)
    }
    
    /// Returns the square of the distance between two vectors.
    ///
    /// - Note: Faster if the real distance is not required in the case of comparing vectors, etc.
    /// - Parameter vector: Another vector
    /// - Returns: Distance to the second vector
    @available(*, deprecated, renamed: "distanceSquared(to:)")
    func distSquared(_ vector: Vector) -> Double {
        simd_distance_squared(simdVector, vector.simdVector)
    }
    
    /// Returns the square of the distance between two vectors.
    ///
    /// - Note: Faster if the real distance is not required in the case of comparing vectors, etc.
    /// - Parameter vector: Another vector
    /// - Returns: Distance to the second vector
    func distanceSquared(to vector: Vector) -> Double {
        simd_distance_squared(simdVector, vector.simdVector)
    }
    
    /// Calculates and returns a vector composed of the cross product between two vectors
    func cross(_ vector: Vector) -> Vector {
        Vector(simd_cross(simdVector, vector.simdVector))
    }
    
    /// Calculates and returns a vector composed of the cross product between two vectors
    func cross2(_ vector: Vector) -> Vector {
        let x = self.y * vector.z - self.z * vector.y
        let y = self.z * vector.x - self.x * vector.z
        let z = self.x * vector.y - self.y * vector.x
        
        return Vector(x, y, z)
    }
    
    /// Calculates the dot product of two vectors.
    func dot(_ vector: Vector) -> Double {
        simd_dot(simdVector, vector.simdVector)
    }
    
    func sign() -> Vector {
        Vector(simd_sign(simdVector))
    }
    
    /// Provide the heading of the receiver
    func heading() -> Angle {
        return Angle(radians: atan2(self.y, self.x))
    }
    
    // MARK: - Transformations
    /// Set the heading of the receiver to the specified angle
    /// - Parameter theta: The new heading
    mutating func rotate(to theta: Angle) {
        let newHeading = theta.radians

        self.x = cos(newHeading) * length()
        self.y = sin(newHeading) * length()

    }
    
    /// Rotate the receiver by the specified angle
    /// - Parameter theta: Angle, in radians, to rotate
    mutating func rotate(by theta: Angle) {
        let newHeading = self.heading() + theta
        rotate(to: newHeading)
    }
    
    mutating func matrixRotate(by theta: Angle) {
        simdVector = simdVector * MatrixTransformation.rotate(by: theta)
    }
    
    /// Rotate the Vector around the specified point
    ///
    /// - Parameters:
    ///   - angle: Angle to rotate by, counterclockwise
    ///   - point: The center point
    mutating func rotate(by angle: Angle, around point: Vector) {
        
        // Offset by the other point
        self -= point

        // Perform the rotation
        matrixRotate(by: angle)
        
        // Restore the point
        self += point

    }
}

extension Vector {
    
    /// Adds two values and produces their sum.
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func + (lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.simdVector + rhs.simdVector)
    }
    
    /// Adds two values and stores the result in the left-hand-side variable
    ///
    /// - Parameters:
    ///   - lhs: The first value to add.
    ///   - rhs: The second value to add.
    public static func += (lhs: inout Vector, rhs: Vector) {
        lhs.simdVector += rhs.simdVector
    }

    
    /// Add the specified value to a vector
    ///
    /// - Parameters:
    ///   - vector: The first value to add.
    ///   - num: The second value to add.
    public static func + (vector: Vector, num: Double) -> Vector {
        Vector(vector.simdVector + num)
    }

    /// Add the specified value to a vector
    ///
    /// - Parameters:
    ///   - vector: The first value to add.
    ///   - num: The second value to add.
    public static func += (vector: inout Vector, num: Double) {
        vector.simdVector += num
    }

    /// Subtracts one vector from another and produces their difference
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    public static func - (lhs: Vector, rhs: Vector) -> Vector {
        Vector(lhs.simdVector - rhs.simdVector)
    }

    /// Subtracts the second vector from the first and stores the difference in the left-hand-side variable
    ///
    /// - Parameters:
    ///   - lhs: The first vector to subtract.
    ///   - rhs: The second vector to subtract.
    public static func -= (lhs: inout Vector, rhs: Vector) {
        lhs.simdVector -= rhs.simdVector
    }

    /// Subtracts one value from another and produces their difference, rounded to a representable value.
    ///
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    public static func - (vector: Vector, num: Double) -> Vector {
        Vector(vector.simdVector - num)
    }
    
    /// Subtracts the second value from the first and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///   - lhs: A numeric value.
    ///   - rhs: The value to subtract from lhs.
    public static func -= (vector: inout Vector, num: Double) {
        vector.simdVector -= num
    }
    
    /// Multiplies two values and produces their product
    ///
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func * (lhs: Vector, num: Double) -> Vector {
        Vector(lhs.simdVector * num)
    }
    
    /// Multiplies two values and produces their product
    ///
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func * (num: Double, lhs: Vector) -> Vector {
        Vector(lhs.simdVector * num)
    }
    
    /// Multiplies two values and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func *= (lhs: inout Vector, num: Double) {
        lhs.simdVector *= num
    }
    
    /// Multiplies two values and produces their product
    ///
    /// Multiplying two `Vector`s calculates the dot product.
    ///
    /// - Parameters:
    ///   - lhs: The first value to multiply.
    ///   - num: The second value to multiply.
    public static func * (lhs: Vector, rhs: Vector) -> Double {
        simd_dot(lhs.simdVector, rhs.simdVector)
    }
    
    /// Returns the quotient of dividing the first value by the second.
    /// - Parameters:
    ///   - lhs: The value to divide.
    ///   - num: The value to divide lhs by.
    public static func / (lhs: Vector, num: Double) -> Vector {
        Vector(lhs.simdVector / num)
    }
    
    /// Divides the first value by the second and stores the quotient in the left-hand-side variable.
    /// - Parameters:
    ///   - lhs: The value to divide.
    ///   - num: The value to divide lhs by.
    public static func /= (lhs: inout Vector, num: Double) {
        lhs.simdVector /= num
    }

    /// Returns the quotient of dividing the first value by the second.
    /// - Parameters:
    ///   - lhs: The value to divide.
    ///   - num: The value to divide lhs by.
    public static func / (num: Double, vector: Vector) -> Vector {
        Vector(num / vector.simdVector)
    }
    
    /// Negate a Vector.
    ///
    /// - Parameter vector: The vector to negate
    public static prefix func - (vector: Vector) -> Vector {
        Vector(-vector.simdVector)
    }
    
    /// Linearly interpret between two vectors
    /// - Parameters:
    ///   - percent: The percent, between `0` and `1`
    ///   - start: The starting Vector
    ///   - end: The ending Vector
    public static func lerp(percent: Double, start: Vector, end: Vector) -> Vector {
        return start + ((end - start) * percent)
    }
}
