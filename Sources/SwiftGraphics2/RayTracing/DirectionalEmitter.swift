//
//  DirectionalEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An emitter that casts a single ray at a given angle
public struct DirectionalEmitter: Emitter, CustomStringConvertible {

	/// The origin of the emitter
	public var origin: Vector

	/// The direction of the ray to be cast
	public var direction: Vector

	/// Visual style for the emitter's rays
	public var style: RayTraceStyle = .line

	/// The rays this emitter casts
	var ray: Ray?

	/// Instantiate a new emitter
	/// - Parameters:
	///   - origin: The emitter's origin
	///   - direction: Direction of the emitter's ray
	public init(_ origin: Vector, direction: Vector) {
		self.origin = origin
		self.direction = direction
	}

	public var description: String {
		"Direction Emitter at \(origin) in \(direction.heading())"
	}

#if Vector3D
	/// Instantiate a new emitter
	/// - Parameters:
	///   - x: `x` coordinate of the origin
	///   - y: `y` coordinate of the origin
	///   - z: `z` coordinate of the origin
	///   - direction: Direction of the emitter's ray
	public init(x: Double, y: Double, z: Double = 0, direction: Vector) {
		self.origin = Vector(x, y, z)
		self.direction = direction
	}
#else
	/// Instantiate a new emitter
	/// - Parameters:
	///   - x: `x` coordinate of the origin
	///   - y: `y` coordinate of the origin
	///   - direction: Direction of the emitter's ray
	public init(x: Double, y: Double, direction: Vector) {
		self.origin = Vector(x, y)
		self.direction = direction
	}
#endif

	/// Instantiate a new emitter
	/// - Parameters:
	///   - origin: The emitter's origin
	///   - direction: Direction of the emitter's ray
	public init(_ origin: Vector, _ direction: Angle) {
		self.origin = origin
		self.direction = Vector(angle: direction)

	}

	/// Instantiate a new emitter
	/// - Parameters:
	///   - x: `x` coordinate of the origin
	///   - y: `y` coordinate of the origin
	///   - direction: Direction of the emitter's ray
	public init(x: Double, y: Double, direction: Angle) {
		self.init(Vector(x, y), direction)
	}

	/// Process the ray casting operations for this emitter.
	///
	/// This method calculates the paths of the emitter's rays, but does not draw them.
	/// Any previous rays will be overwritten.
	/// - Parameter objects: The objects with which the rays will interact
	public mutating func run(objects: [RayTracable]) {
		let ray = makeRay()
		ray.run(objects: objects)

		self.ray = ray
	}

	public func makeRay() -> Ray {
		Ray(origin: origin, direction: direction)
	}

//	/// Draw the paths taken by the emitter's rays.
//	///
//	/// This method does not perform any ray tracing.
//	public func draw() {
//		guard let path = ray?.path else { return }
//		self.drawIntersections(path)
//	}
//
//	/// Draws a representation of the emitter suitable for debugging.
//	/// - Parameter context: Context in which to draw
//	public func debugDraw(in context: CGContext) {
//		let ray = Ray(origin: origin.copy(), direction: direction.copy())
//		ray.debugDraw(in: context)
//	}

}

extension DirectionalEmitter: SVGDrawable {
	public func svgElement() -> XMLElement? {
		let element = XMLElement(name: "g")

		element.addChild(origin.svgElement())

		switch style {
		case .line:
			element.addChild(ray?.path.svgElement())
		case .point:
			element.addChild(ray?.path.points.last?.svgElement())
		}

		return element
	}
}
