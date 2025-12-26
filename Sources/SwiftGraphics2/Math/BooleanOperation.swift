//
//  BooleanOperation.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//


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
