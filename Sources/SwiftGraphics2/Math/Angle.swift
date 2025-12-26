//
//  Angle.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation

/// Represents an angle, both in degrees and radians.
public struct Angle {

    /// Create a new Angle from degrees.
    /// - Parameter value: The angle in degrees.
    public static func degrees(_ value: Double) -> Angle {
        Angle(degrees: value)
    }

	/// Create a new Angle from degrees.
	/// - Parameter value: The angle in degrees.
	public static func degrees(_ value: Int) -> Angle {
		Angle(degrees: Double(value))
	}

    /// Create a new Angle from radians.
    /// - Parameter value: The angle in radians.
    public static func radians(_ value: Double) -> Angle {
        Angle(radians: value)
    }
    
    /// The degree value of the angle.
    public let degrees: Double
    
    /// The radian value of the angle.
    public let radians: Double
    
    /// Create a new Angle from degrees.
    /// - Parameter degrees: The angle in degrees.
    public init(degrees: Double) {
        self.degrees = degrees
        self.radians = degrees * Double.pi / 180
    }
    
    /// Create a new Angle from degrees.
    /// - Parameter radians: The angle in degrees.
	public init(radians: Double) {
        self.degrees = radians * 180 / Double.pi
        self.radians = radians
    }
    
}

extension Angle: Comparable, Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.radians == rhs.radians
	}

	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.radians < rhs.radians
	}
}

public extension Angle {

	/// Add two angles together.
	/// - Returns: The sum of the two angles.
	static func + (lhs: Angle, rhs: Angle) -> Angle {
		Angle(degrees: lhs.degrees + rhs.degrees)
	}

	/// Add two angles together.
	/// - Returns: The sum of the two angles.
	static func += (lhs: inout Angle, rhs: Angle) {
		lhs = lhs + rhs
	}

	/// Add two angles together.
	/// - Returns: The difference of the two angles.
	static func - (lhs: Angle, rhs: Angle) -> Angle {
		Angle(degrees: lhs.degrees - rhs.degrees)
	}

	/// Add two angles together.
	/// - Returns: The sum of the two angles.
	static func -= (lhs: inout Angle, rhs: Angle) {
		lhs = lhs - rhs
	}

	public static func * (lhs: Angle, rhs: Angle) -> Angle {
		Angle(degrees: lhs.degrees * rhs.degrees)
	}

	public static func *= (lhs: inout Angle, rhs: Angle) {
		lhs = lhs * rhs
	}

	public static func / (lhs: Angle, rhs: Angle) -> Angle {
		Angle(degrees: lhs.degrees / rhs.degrees)
	}

	public static func /= (lhs: inout Angle, rhs: Angle) {
		lhs = lhs / rhs
	}


}

public extension Angle {
    /// Pi
    static let pi = Angle(radians: Double.pi)
    
    /// Pi, multiplied by two.
    static let twoPi = Angle(radians: Double.pi * 2)
    
    /// Pi, divided by two.
    static let halfPi = Angle(radians: Double.pi / 2)
    
    
    /// A full circle
    static let fullCircle = Angle.twoPi
    
    /// A half circle
    static let halfCircle = Angle.pi
    
    /// A quarter circle
    static let quarterCircle = Angle.halfPi
}

extension Angle: SignedNumeric {
	public init?<T>(exactly source: T) where T : BinaryInteger {
		self = .degrees(Double(source))
	}

	public var magnitude: Double { abs(degrees) }

	public init(integerLiteral value: Int) {
		self = .degrees(Double(value))
	}

	public mutating func negate() {
		self = Angle(degrees: -degrees)
	}

	public func negated() -> Angle {
		Angle(degrees: -degrees)
	}
}

extension Angle: Strideable {
	public func advanced(by n: Angle) -> Angle {
		self + n
	}

	public func distance(to other: Angle) -> Angle {
		other - self
	}
}

extension Angle: CustomStringConvertible {
	public var description: String {
		"\(degrees)º"
	}
}
