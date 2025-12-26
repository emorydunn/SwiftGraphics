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

