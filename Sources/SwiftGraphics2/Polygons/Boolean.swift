//
//  File.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//

import Foundation

public struct BooleanGroup: Drawable, SVGDrawable {

	let operation: BooleanOperation

	let body: Drawable

	public init(operation: BooleanOperation = .add, @SketchBuilder body: () -> GroupDrawable) {
		self.operation = operation
//		self.body = body()
		var shapes = body().shapes.compactMap { $0 as? (ClosedShape & Intersectable & Drawable) }

		switch shapes.count {
		case 0:
			self.body = EmptyDrawable()
		default:
			let firstShape = Array(shapes.dropFirst())
			let op = shapes[0].booleanOperation(shapes, operation)
			self.body = GroupDrawable(op)
		}

	}

	public func svgElement() -> XMLElement? {
		body.svgElement()
	}

}


extension ClosedShape where Self: Intersectable {

	/// Perform a Boolean operation between the specified shapes.
	/// - Parameters:
	///   - shapes: Shapes to operate on
	///   - operation: The operation to perform
	/// - Returns: An array of the resulting paths
	public func booleanOperation(_ shapes: [Intersectable & ClosedShape], _ operation: BooleanOperation = .add) -> [BezierPath] {

//		var shapes = shapes
//		shapes.removeAll { $0 == self }

		var intersections = shapes.reduce(into: [Vector]()) { (result, poly) in
			result.append(contentsOf: self.intersections(with: poly))
		}

		// Add the rectangle to the intersections
		if case .addIntersecting(let rect) = operation {
			intersections.append(contentsOf: self.intersections(with: rect))
		}

		// If there are no intersections, return a full shape
		guard intersections.count >= 2 else {
			return bezierCurve(start: 0, end: .twoPi)
		}

		var angles: [Angle] = intersections.map {
			angle(ofPoint: $0)
		}
		angles.sort()

		if let firstAngle = angles.first, let lastAngle = angles.last {
			if firstAngle < lastAngle {
				angles.append(firstAngle + .twoPi)
			} else {
				angles.append(firstAngle)
			}
		}

		return angles.paired().reduce(into: [BezierPath]()) { (result, arg1) in

			let (start, end) = arg1

			let halfPoint = self.point(at: .radians((end + start).radians / 2))
			let inOtherShape = shapes.map { $0.contains(point: halfPoint) }

			switch operation {
			case .addIntersecting(let rect):
				// The half-way point can't be in another shape, but must be inside the rectangle
				guard inOtherShape.allFalse() && rect.contains(point: halfPoint) else { return }
			case .add:
				guard inOtherShape.allFalse() else { return }
			case .intersect:
				let inOneOther = inOtherShape.reduce(into: false) { (result, contained) in
					result = result || contained
				}

				guard inOneOther else { return }

			case .globalIntersect:
				guard inOtherShape.allTrue() else { return }
			}

			let arcs: [BezierPath] = bezierCurve(start: start, end: end)

			result.append(contentsOf: arcs)
		}

	}

}

extension Circle {

	/// Create a Bézier arc of the circle between the two points.
	///
	/// - Parameters:
	///   - start: Starting angle
	///   - end: Ending Angle
	/// - Returns: An array of `BezierPath` which draw the shape
	public func bezierCurve(start: Angle, end: Angle) -> [BezierPath] {
		let distance = Angle.quarterCircle

		print("Creating circle bezier form \(start) to \(end)")

		return stride(from: start, to: end, by: distance).map { arcStart in
			print(arcStart)

			let size: Angle
			if arcStart + distance < end {
				size = distance
			} else {
				size = end - arcStart
			}

			let arc = acuteArc(start: arcStart, size: size)
			return arc
		}
	}
}

extension Rectangle {

	/// Create a Bézier path of the rectangle between the two points.
	///
	/// This method returns a single `BezierPath` which draws lines from the start to
	/// end, passing through each corner.
	///
	/// - Parameters:
	///   - start: Starting angle
	///   - end: Ending Angle
	/// - Returns: An array of `BezierPath` which draw the shape
	public func bezierCurve(start: Angle, end: Angle) -> [BezierPath] {

		var corners = [
			angle(ofPoint: topLeft),
			angle(ofPoint: topRight),
			angle(ofPoint: bottomRight),
			angle(ofPoint: bottomLeft),
		]

		corners = corners.map { angle in
			var angle = angle
			// Ensure angles are positive rotation from 0
			if angle < 0 {
				angle += .twoPi
			}

			// Offset the angle
			angle -= start

			// If the offset angle wrapped past 360
			if angle > .twoPi {
				angle -= .twoPi
			}
			return angle
		}

		// Filter out angles not between the start and end points
		let newAngles = corners.filter { (angle) -> Bool in
			angle > 0 && angle < end - start
		}

		// Remove offset & add the starting and ending points
		corners = newAngles.map { $0 + start }
		corners.append(start)
		corners.append(end)

		// Sort the corners
		corners.sort()

		// Create a Bézier from the angles
//		let bezier1 = BezierPath(start: point(at: start))
//		bezier1.points = corners.map { BezierPath.Point(point: point(at: $0)) }

		return []
	}
}
