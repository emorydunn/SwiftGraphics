//
//  Fresnel.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-29.
//


public struct Fresnel: RayDrawable, CustomStringConvertible {
	let shape: Line

	public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
		self.shape = Line(x1, y1, x2, y2)
	}

	public init(_ line: Line) {
		self.shape = line
	}

	public func rayIntersection(_ ray: Ray) -> Vector? {
		shape.rayIntersection(ray)
	}

	public func rayIntersectionDistance(_ ray: Ray) -> Double? {
		shape.rayIntersectionDistance(ray)
	}

	public func interface(of intersection: Vector) -> Line {
		shape
	}

	public func modifyRay(_ ray: Ray) {
		if shape.normal().dot(ray.direction) < 0 {
			ray.terminateRay()
		} else {
			ray.direction = shape.normal().normalized()
		}
	}

	public var description: String {
		"Fresnel at \(shape.center)"
	}
}