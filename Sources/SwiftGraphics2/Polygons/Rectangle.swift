//
//  Rectangle.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import simd
//import Silica

/// A rectangle defined by its center, width, and height.
public struct Rectangle: Polygon, Drawable, Intersectable {
    
    /// The center of the rectangle
    public var origin: Vector
    
    /// The width of the rectangle
    public var width: Double
    
    /// The height of the rectangle
    public var height: Double
    
    /// The angle of rotation of the rectangle
    public var rotation: Angle

    /// The points that make up the rectangle
    public var points: [Vector] { makePolygon() }

    public init(center: Vector, width: Double, height: Double, rotation: Angle = .degrees(0)) {
        self.origin = center
        self.height = height
        self.width = width
        self.rotation = rotation
    }
    
    public init(centerX x: Double, y: Double, width: Double, height: Double, rotation: Angle = .degrees(0)) {
        self.origin = Vector(x, y)
        self.height = height
        self.width = width
        self.rotation = rotation
    }

	public init(size: Size, rotation: Angle = .degrees(0)) {
		self.origin = size.center
		self.width = size.width
		self.height = size.height
		self.rotation = rotation
	}
    
    /// Calculates the points of the rectangle by applying a matrix transformation.
    ///
    /// The points start in the top left and proceed clockwise:
    /// ```
    /// +--------+
    /// |0      1|
    /// |        |
    /// |3      2|
    /// +--------+
    /// ```
    /// - Returns: An array of Vectors making up the polygon.
    public func makePolygon() -> [Vector] {
        // Center rectangle
        [
            Vector(-width / 2, -height / 2, transformation: compoundMatrix),
            Vector( width / 2, -height / 2, transformation: compoundMatrix),
            Vector( width / 2,  height / 2, transformation: compoundMatrix),
            Vector(-width / 2,  height / 2, transformation: compoundMatrix)
        ]
    }

	public func modifyRay(_ ray: Ray) {
		ray.terminateRay()
	}
}

extension Rectangle: RayTracable {
	public func rayIntersection(_ ray: Ray) -> Vector? {
		[
			topEdge.rayPlaneIntersection(origin: ray.origin, dir: ray.direction),
			rightEdge.rayPlaneIntersection(origin: ray.origin, dir: ray.direction),
			bottomEdge.rayPlaneIntersection(origin: ray.origin, dir: ray.direction),
			leftEdge.rayPlaneIntersection(origin: ray.origin, dir: ray.direction)
		]
			.compactMap { $0 }
			.sorted { lhs, rhs in
				lhs.distance(to: ray.origin) < rhs.distance(to: ray.origin)
			}
			.first
	}
}

extension Rectangle {
	/// Returns the point on the rectangle where the specified angle originating from the center intersects
	/// - Parameter theta: Angle in radians
	public func point(at angle: Angle) -> Vector {
		let angleVector = Vector(angle: angle)

		if let inter = topEdge.rayPlaneIntersection(origin: origin, dir: angleVector) {
			return inter
		} else if let inter = rightEdge.rayPlaneIntersection(origin: origin, dir: angleVector) {
			return inter
		} else if let inter = bottomEdge.rayPlaneIntersection(origin: origin, dir: angleVector) {
			return inter
		} else if let inter = leftEdge.rayPlaneIntersection(origin: origin, dir: angleVector) {
			return inter
		} else {
			fatalError("Invalid origin in Rectangle.")
		}
	}

	public func angle(ofPoint point: Vector) -> Angle {
		let hypot = sqrt(width.squared() + height.squared())
		let circle = Circle(center: origin, radius: hypot)

		return circle.angle(ofPoint: point)
	}
}

extension Rectangle {

	var compoundMatrix: double3x3 {
		let transMatrix = MatrixTransformation.translate(vector: origin)
		let rotMatrix = MatrixTransformation.rotate(by: rotation)

		return transMatrix * rotMatrix
	}

	/// A `Line` representing the top edge
	public var topEdge: Line {
		Line(start: topLeft, end: topRight)
	}

	/// A `Line` representing the bottom edge
	public var bottomEdge: Line {
		Line(start: bottomLeft, end: bottomRight)
	}

	/// A `Line` representing the left edge
	public var leftEdge: Line {
		Line(start: topLeft, end: bottomLeft)
	}

	/// A `Line` representing the right edge
	public var rightEdge: Line {
		Line(start: topRight, end: bottomRight)
	}

	/// Calculates the top-left point of the rectangle by applying a matrix transformation.
	///
	/// The points start in the top left and proceed clockwise:
	/// ```
	/// +--------+
	/// |0      1|
	/// |        |
	/// |3      2|
	/// +--------+
	/// ```
	public var topLeft: Vector {
		Vector(-width / 2, -height / 2, transformation: compoundMatrix)
	}

	/// Calculates the top-right point of the rectangle by applying a matrix transformation.
	///
	/// The points start in the top left and proceed clockwise:
	/// ```
	/// +--------+
	/// |0      1|
	/// |        |
	/// |3      2|
	/// +--------+
	/// ```
	public var topRight: Vector {
		Vector( width / 2, -height / 2, transformation: compoundMatrix)
	}

	/// Calculates the bottom-left point of the rectangle by applying a matrix transformation.
	///
	/// The points start in the top left and proceed clockwise:
	/// ```
	/// +--------+
	/// |0      1|
	/// |        |
	/// |3      2|
	/// +--------+
	/// ```
	public var bottomLeft: Vector {
		Vector(-width / 2,  height / 2, transformation: compoundMatrix)
	}

	/// Calculates the bottom-right point of the rectangle by applying a matrix transformation.
	///
	/// The points start in the top left and proceed clockwise:
	/// ```
	/// +--------+
	/// |0      1|
	/// |        |
	/// |3      2|
	/// +--------+
	/// ```
	public var bottomRight: Vector {
		Vector( width / 2,  height / 2, transformation: compoundMatrix)
	}
}

extension Rectangle: SVGDrawable {
    public func svgElement() -> XMLElement? {
        let element = XMLElement(name: "rect")
        
        let transMatrix = MatrixTransformation.translate(vector: origin)
        let corner = Vector(-width / 2,  -height / 2, transformation: transMatrix)
        
        element.addAttribute(corner.x, forKey: "x")
        element.addAttribute(corner.y, forKey: "y")
        element.addAttribute(width, forKey: "width")
        element.addAttribute(height, forKey: "height")
        
        if rotation.degrees != 0 {
			element.addAttribute("rotate(\(rotation.negated().degrees),\(origin.x),\(origin.y))", forKey: "transform")
        }
        
        element.strokeColor(Color.black)
        element.strokeWidth(1)
        element.fillColor(nil)

        return element
    }
}

//extension Rectangle: PNGDrawable {
//	public func draw(in context: Silica.CGContext) {
//		
//		// Create the rectangle
//		let transMatrix = MatrixTransformation.translate(vector: origin)
//		let corner = Vector(-width / 2,  -height / 2, transformation: transMatrix)
//		let rect = CGRect(x: corner.x, y: corner.y, width: width, height: height)
//
//		// Save the state and rotate
//		context.saveGState()
//		context.rotateBy(rotation.degrees)
//
//		// Draw the rect
//		context.addRect(rect)
//
//		context.strokePath()
//		context.fillPath()
//
//		// Restore the state
//		context.restoreGState()
//	}
//}

extension Rectangle: CustomStringConvertible {
	public var description: String {
		"Rect \(origin.x), \(origin.y) \(width) x \(height)"
	}
}
