//
//  ClosedShape.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//

import Foundation

public protocol ClosedShape {
	
	var boundingBox: Rectangle { get }

	func contains(point: Vector) -> Bool

	/// Return the intersection point of the specified angle from the center of the shape
	/// - Parameter angle: The angle
	func point(at angle: Angle) -> Vector

	/// The angle of a point relative to the center
	/// - Parameter point: The point to to determine the angle between.
	func angle(ofPoint point: Vector) -> Angle

	/// Create a Bézier path representing the shape
	///
	/// - Parameters:
	///   - start: Starting angle
	///   - end: Ending Angle
	/// - Returns: An array of `BezierPath` which draw the shape
	func bezierCurve(start: Angle, end: Angle) -> [BezierPath]
}

extension ClosedShape {
	/// Return an array of points at the specified angular distance apart
	/// - Parameter angle: Angle in degrees
	public func pointsDistributed(every angle: Angle,
								  starting: Angle = .degrees(0),
								  ending: Angle = .degrees(360)) -> [Vector] {

		stride(from: starting, to: ending, by: angle).map { angle in
			point(at: angle)
		}
	}
}
