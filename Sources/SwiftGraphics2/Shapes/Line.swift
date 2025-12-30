//
//  Line.swift
//  
//
//  Created by Emory Dunn on 10/13/21.
//

import Foundation

public struct Line: Shape, Drawable {
    
    /// The starting point of the line
    public var start: Vector

    /// The ending point of the line
    public var end: Vector
    
    public var length: Double { end.distance(to: start) }
    
    /// The midpoint of the line
    public var center: Vector {
        Vector(
            (end.x + start.x) / 2,
            (end.y + start.y) / 2
        )
    }
    
    public init(start: Vector, end: Vector) {
        self.start = start
        self.end = end
    }
    
    /// Instantiate a new `Line` from coordinates
    /// - Parameters:
    ///   - x1: Starting X coordinate
    ///   - y1: Starting Y coordinate
    ///   - x2: Ending X coordinate
    ///   - y2: Ending Y coordinate
    public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
        self.start = Vector(x1, y1)
        self.end = Vector(x2, y2)
    }

	/// Instantiate a new `Line` from a center point
	/// - Parameters:
	///   - center: The center of the line
	///   - direction: The direction of the line
	///   - length: The length of the line
	public init(center: Vector, direction: Angle, length: Double) {
		let dir = Vector(angle: direction)
		self.init(
			center.x - dir.x * (length / 2),
			center.y - dir.y * (length / 2),
			center.x + dir.x * (length / 2),
			center.y + dir.y * (length / 2)
		)
	}

	/// Instantiate a new `Line` from an origin of a specified length
	/// - Parameters:
	///   - origin: The origin of the line
	///   - direction: The direction of the line
	///   - length: The length of the line
	public init(origin: Vector, direction: Angle, length: Double) {
		let dir = Vector(angle: direction)
		self.init(
			origin.x,
			origin.y,
			origin.x + dir.x * length,
			origin.y + dir.y * length
		)
	}

    /// Determine whether a point is on the line
    ///
    /// From https://gamedev.stackexchange.com/a/57746
    ///
    /// - Parameter point: Whether the point is on the line
    public func contains(_ point: Vector) -> Bool {
		start.cross(point).sign() == point.cross(end).sign()
    }
    
    /// Calculate the vector normal of the line
    ///
    /// - Returns: A `Vector` whose heading is perpendicular to the line
    public func normal() -> Vector {
        //calculate base top normal
        let baseDelta = (end - start).normalized()
        let normal = Vector(-baseDelta.y, baseDelta.x)

        return normal
    }
    
    public func slope() -> Double {
        return (end.y - start.y) / (end.x - start.x)
    }

    /// Returns the angle of the line based on the slope
    public func angle() -> Angle {
        return Angle(radians: atan(slope()))
    }
    
    /// Return a point at the specified distance of the line
    /// - Parameter distance: Distance from the end point
    public func point(at distance: Double) -> Vector {
        var v = (end - start).normalized() // swiftlint:disable:this identifier_name
        v *= distance

        return start + v
    }

    ///  Linear interpolate the vector to another vector
    /// - Parameter percent: the amount of interpolation; some value between 0.0 and 1.0
    /// - Returns: A Vector between the original two
    public func lerp(_ percent: Double) -> Vector {
        Vector.lerp(percent: percent, start: start, end: end)
    }
    
    public func pointOnPerimeter(_ t: Double) -> Vector {
        Vector.lerp(percent: t, start: start, end: end)
    }

    /// A Rectangle that contains the receiver
//    public var boundingBox: Rectangle {

//        Rectangle(
//        Rectangle(
//            x: min(start.x, end.x),
//            y: min(start.y, end.y),
//            width: abs(end.x - start.x),
//            height: abs(end.y - start.y)
//        )

//    }

	/// Calculate the intersection point of a ray and a plane defined by the Line
	/// - Parameters:
	///   - origin: Origin of the ray
	///   - dir: Direction of the ray
	/// - Returns: The point of intersection, if the ray intersections the plane
	public func rayPlaneIntersection(origin: Vector, dir: Vector) -> Vector? {
		guard let distance = distanceToIntersection(origin: origin, dir: dir.normalized()) else {
			return nil
		}
		
		let norm = normal()
		let denom = norm.dot(dir)

		let p0 = center - origin
		let t = p0.dot(norm) / denom

		guard t >= 0 else { return nil }
		let pHit = origin + (dir * t)

		return pHit
	}

	/// Calculate the distance from a ray to the intersection with the line.
	///
	/// Adapted from https://stackoverflow.com/a/32146853.
	public func distanceToIntersection(origin: Vector, dir: Vector) -> Double? {
		let v1 = origin - start
		let v2 = end - start
		let v3 = Vector(-dir.y, dir.x, 0)

		let dot = v2 * v3
		guard abs(dot) > 0.000001 else {
			return nil
		}

		let t1: Double = v2.crossProduct(v1) / dot
		let t2 = (v1 * v3) / dot

		if t1 >= 0 && (t2 >= 0 && t2 <= 1) {
			return t1
		}

		return nil
	}
}

extension Line: RayTracable {
	public func rayIntersection(_ ray: Ray) -> Vector? {
		rayPlaneIntersection(origin: ray.origin, dir: ray.direction)
	}

	public func rayIntersectionDistance(_ ray: Ray) -> Double? {
		distanceToIntersection(origin: ray.origin, dir: ray.direction)
	}

	public func interface(of intersection: Vector) -> Line {
		self
	}

}

extension Line: SVGDrawable {
    public func svgElement() -> XMLElement? {
        let element = XMLElement(name: "line")
        
        element.addAttribute(start.x, forKey: "x1")
        element.addAttribute(start.y, forKey: "y1")
        element.addAttribute(end.x, forKey: "x2")
        element.addAttribute(end.y, forKey: "y2")

        element.strokeColor(Color.black)
        element.strokeWidth(1)

        return element
    }
}
