//
//  Circle.swift
//  
//
//  Created by Emory Dunn on 10/13/21.
//

import Foundation

public struct Circle: ClosedShape, Drawable, RayTracable, Intersectable {

    /// Radius of the circle
    public var radius: Double

    /// Center point of the circle
    public var center: Vector

    /// The diameter of the circle
    public var diameter: Double { radius * 2 }
    
    /// Instantiate a new `Circle`
    /// - Parameters:
    ///   - center: Center of the circle
    ///   - radius: Radius of the circle
    public init(center: Vector, radius: Double) {
        self.center = center
        self.radius = radius
    }

    /// Instantiate a new `Circle`
    /// - Parameters:
    ///   - x: Center X coordinate
    ///   - y: Center Y coordinate
    ///   - radius: Radius of the circle
    public init(x: Double, y: Double, radius: Double) {
        self.init(center: Vector(x, y), radius: radius)

    }
    
    public func pointOnPerimeter(_ t: Double) -> Vector {
        return point(at: Angle(radians: Double.pi * t))
    }
    
    /// Return the intersection point of the specified angle from the center of the circle
    /// - Parameter angle:The angle
    public func point(at angle: Angle) -> Vector {
        let x = center.x + radius * cos(angle.radians)
        let y = center.y + radius * sin(angle.radians)
        
        return Vector(x, y)
    }

	public func angle(ofPoint point: Vector) -> Angle {
		let unitInt = point - center
		return .radians(atan2(unitInt.y, unitInt.x))
	}

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        Rectangle(center: center, width: diameter, height: diameter)
    }

	/// Generate a cubic Bézier representing an arc around a circle.
	///
	/// Adapted from [Joe Cridge](https://www.joecridge.me/bezier.pdf)
	/// - Note: Bézier approximations of circles only work up to ~90º
	/// - Parameters:
	///   - start: Starting angle of the arc, in radians
	///   - size: Size of the arc, in radians
	///   - circle: Circle to make the arc on
	public func acuteArc(start: Angle, size: Angle) -> BezierPath {

		let alpha = size.radians / 2
		let cosAlpha = cos(alpha)
		let sinAlpha = sin(alpha)
		let cotAlpha = 1 / tan(alpha)

		let phi = start.radians + alpha  // This is how far the arc needs to be rotated.
		let cosPhi = cos(phi)
		let sinPhi = sin(phi)

		let lambda = (4 - cosAlpha) / 3
		
		let mu = sinAlpha + (cosAlpha - lambda) * cotAlpha

		let pointA = Vector(cos(start.radians), sin(start.radians), 0) * radius + center
		let pointB = Vector(
			lambda * cosPhi + mu * sinPhi,
			lambda * sinPhi - mu * cosPhi,
			0
		) * radius + center
		let pointC = Vector(
			lambda * cosPhi - mu * sinPhi,
			lambda * sinPhi + mu * cosPhi,
			0
		) * radius + center
		let pointD = Vector(cos(start.radians + size.radians), sin(start.radians + size.radians), 0) * radius + center

		return BezierPath(pointA, pointB, pointC, pointD)
	}

	/// Determine whether the specified point is inside the circle
	///
	/// This method compares the distance between the center and point to the radius of the circle.
	/// - Parameter point: A Boolean indicating whether the point is contained by the circle
	public func contains(point: Vector) -> Bool {
		let unitPoint = point - center
		return sqrt(unitPoint.x.squared() + unitPoint.y.squared()) < radius
	}

	public func rayIntersection(_ ray: Ray) -> Vector? {
		guard let distance = rayIntersectionDistance(ray) else { return nil }

		return ray.origin + ray.direction * distance
	}

	public func rayIntersectionDistance(_ ray: Ray) -> Double? {
		let originDiffs = ray.origin - center

		let a = ray.direction.magSq()
		let b = 2 * ray.direction.dot(originDiffs)
		let c = originDiffs.magSq() - radius.squared()

		let discr = b.squared() - 4 * a * c

		guard discr > 0 else { return nil }

		let g = 1 / (2 * a)
		let determ = g * sqrt(discr)
		let newB = -b * g

		let t0 = newB + determ
		let t1 = newB - determ

		guard let tValue = [t0, t1].filter({ $0 > 0 && $0.rounded() != 0}).sorted().first else {
			return nil
		}

		return tValue
	}
}

extension Circle: SVGDrawable {
    public func svgElement() -> XMLElement? {
        let element = XMLElement(name: "circle")
        
        element.addAttribute(center.x, forKey: "cx")
        element.addAttribute(center.y, forKey: "cy")
        element.addAttribute(radius, forKey: "r")
        
        element.strokeColor(Color.black)
        element.strokeWidth(1)
        element.fillColor(nil)
        
        return element
    }
}
