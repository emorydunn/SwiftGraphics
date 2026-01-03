//
//  CircleEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle that emits rays radiating out from its perimeter
public struct ShapeEmitter: Emitter {

	public typealias Source = ClosedShape & RayTracable & SVGDrawable

	let emitterSource: Source

	let startAngle: Angle
	let endAngle: Angle
	let stepAngle: Angle

	/// Visual style for the emitter's rays
	public var style: RayTraceStyle = .line

	/// The rays this emitter casts
	public var rays: [Ray] = []

	/// Instantiate a new emitter at the specified coordinates
	/// - Parameters:
	///   - x: Center X coordinate
	///   - y: Center Y coordinate
	///   - radius: Radius of the emitter
	///   - rayStep: Angle between emitted rays
	public init(x: Double, y: Double, radius: Double, startAngle: Angle = 0, endAngle: Angle = 360, stepAngle: Angle) {
		self.emitterSource = Circle(x: x, y: y, radius: radius)
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.stepAngle = stepAngle
	}

	/// Instantiate a new emitter at the specified coordinates
	/// - Parameters:
	///   - x: Center X coordinate
	///   - y: Center Y coordinate
	///   - radius: Radius of the emitter
	///   - rayStep: Angle between emitted rays
	public init(x: Double, y: Double, radius: Double, direction: Angle, spread: Angle, stepAngle: Angle) {
		self.emitterSource = Circle(x: x, y: y, radius: radius)
		self.startAngle = direction - spread / 2
		self.endAngle = direction + spread / 2
		self.stepAngle = stepAngle
	}

	/// Instantiate a new emitter at the specified coordinates
	/// - Parameters:
	///   - x: Center X coordinate
	///   - y: Center Y coordinate
	///   - radius: Radius of the emitter
	///   - rayStep: Angle between emitted rays
	public init(center: Vector, radius: Double, startAngle: Angle = 0, endAngle: Angle = 360, stepAngle: Angle) {
		self.emitterSource = Circle(center: center, radius: radius)
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.stepAngle = stepAngle
	}

	/// Instantiate a new emitter at the specified coordinates
	/// - Parameters:
	///   - x: Center X coordinate
	///   - y: Center Y coordinate
	///   - radius: Radius of the emitter
	///   - rayStep: Angle between emitted rays
	public init(_ shape: Source, startAngle: Angle = 0, endAngle: Angle = 360, stepAngle: Angle) {
		self.emitterSource = shape
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.stepAngle = stepAngle
	}

	/// Instantiate a new emitter at the specified coordinates
	/// - Parameters:
	///   - x: Center X coordinate
	///   - y: Center Y coordinate
	///   - radius: Radius of the emitter
	///   - rayStep: Angle between emitted rays
	public init(_ shape: Source, direction: Angle, spread: Angle, stepAngle: Angle) {
		self.emitterSource = shape
		self.startAngle = direction - spread / 2
		self.endAngle = direction + spread / 2
		self.stepAngle = stepAngle
	}

	/// Process the ray casting operations for this emitter.
	///
	/// This method calculates the paths of the emitter's rays, but does not draw them.
	/// Any previous rays will be overwritten.
	/// - Parameter objects: The objects with which the rays will interact
	public mutating func run(objects: [RayTracable], initialIndex: Double) {
		self.rays = stride(from: startAngle, to: endAngle, by: stepAngle).map { angle in
			let origin = emitterSource.point(at: angle)
			let ray = Ray(
				origin: origin,
				direction: Vector(angle: angle),
				initialIndex: initialIndex
			)

			ray.run(objects: objects)
			return ray
		}
	}
}

extension ShapeEmitter: SVGDrawable {
	public func svgElement() -> XMLElement? {
		let element = XMLElement(name: "g")

		element.addChild(emitterSource.svgElement())

		for ray in rays {
			switch style {
			case .line:
				element.addChild(ray.svgElement())
			case .point:
				element.addChild(ray.path.last?.svgElement())
			}
		}

		return element
	}
}

extension ShapeEmitter: RayTracable {
	public func rayIntersection(_ ray: Ray) -> Vector? {
		emitterSource.rayIntersection(ray)
	}

	public func rayIntersectionDistance(_ ray: Ray) -> Double? {
		emitterSource.rayIntersectionDistance(ray)
	}

	public func interface(of intersection: Vector) -> Vector {
		emitterSource.interface(of: intersection)
	}
}
