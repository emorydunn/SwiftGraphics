//
//  Intersectable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-24.
//


import Foundation

/// Any shape that can calculate points of intersection between itself and a `Line` or `Vector`
public protocol Intersectable: Shape {
	/// Find any intersection points between the receiver and the specified line
	/// - Parameter line: Line to intersect
	func intersections(with otherShape: Intersectable) -> [Vector]
}

extension Intersectable where Self: Polygon {
	/// Return an array of points at the specified angular distance apart
	/// - Parameter angle: Angle in degrees
	public func pointsDistributed(every angle: Angle,
								  starting: Angle = .degrees(0),
								  ending: Angle = .degrees(360)) -> [Vector] {

//		stride(from: starting, to: ending, by: angle).map { angle in
//			point(at: angle.toRadians())
//		}
		// TODO: Fix this
		[]

	}
}
