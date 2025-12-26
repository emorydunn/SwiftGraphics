//
//  CircleEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A circle that emits rays radiating out from its perimeter
public struct CircleEmitter: Emitter {

	let circle: Circle

	let startAngle: Angle
	let endAngle: Angle
	let stepAngle: Angle

	/// Angle of the step between emitted rays
	///
	/// The value is clamped to a minimum of `0`
	public var rayStep: Int {
		didSet {
			if rayStep < 1 {
				rayStep = 1
			}
		}
	}

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
	public init(x: Double, y: Double, radius: Double, startAngle: Angle = 0, endAngle: Angle = 360, stepAngle: Angle, rayStep: Int) {
		self.rayStep = rayStep
		self.circle = Circle(x: x, y: y, radius: radius)
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
	public init(center: Vector, radius: Double, startAngle: Angle = 0, endAngle: Angle = 360, stepAngle: Angle,  rayStep: Int) {
		self.rayStep = rayStep
		self.circle = Circle(center: center, radius: radius)
		self.startAngle = startAngle
		self.endAngle = endAngle
		self.stepAngle = stepAngle
	}

	/// Process the ray casting operations for this emitter.
	///
	/// This method calculates the paths of the emitter's rays, but does not draw them.
	/// Any previous rays will be overwritten.
	/// - Parameter objects: The objects with which the rays will interact
	public mutating func run(objects: [RayTracable]) {

		// Nothing to do if there are no rays
		guard rayStep > 0 else { return }

//		let stepAngle = Angle(degrees: 360 / Double(rayStep))

		self.rays = stride(from: startAngle, to: endAngle, by: stepAngle).map { angle in
			let origin = circle.point(at: angle)

			print(angle, origin)

			let ray = Ray(
				origin: origin,
				direction: Vector(angle: angle)
			)
			ray.run(objects: objects)
			return ray
		}
	}

}

extension CircleEmitter: SVGDrawable {
	public func svgElement() -> XMLElement? {
		let element = XMLElement(name: "g")

		element.addChild(circle.svgElement())

		for ray in rays {
			element.addChild(ray.path.svgElement())
		}

		return element
	}
}

extension CircleEmitter: RayTracable {
	public func rayIntersection(_ ray: Ray) -> Vector? {
		circle.rayIntersection(ray)
	}
}
