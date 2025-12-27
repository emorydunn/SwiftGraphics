//
//  RayTracable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-24.
//
import Foundation

/// A shape that can interact with a `Ray`
public protocol RayTracable {
    
    /// Return the intersection of a ray
    /// - Parameters:
    ///   - ray: The `Ray` to intersect
    func rayIntersection(_ ray: Ray) -> Vector?

	func rayIntersectionDistance(_ ray: Ray) -> Double?

    /// Modify the path of a ray.
    ///
    /// The default implementation of this method terminates the `Ray`.
    /// - Parameter ray: The ray to modify
    func modifyRay(_ ray: Ray)
}

public extension RayTracable {
    
    /// Modify the path of a ray.
    ///
    /// The default implementation of this method terminates the `Ray`.
    func modifyRay(_ ray: Ray) {
        ray.terminateRay()
    }

	/// Calculate the angle of deflection using Snell's Law of Reflection
	/// - Parameters:
	///   - dir: The angle of intersection
	///   - interface: The interface
	///   - refraction: The refraction index of the material
	///   - extIndex: The refraction index of the exterior material
	/// - Returns: A `Vector` rotated by the angle of reflection
	func deflectionAngle(for dir: Vector, at interface: Line, refraction: Double = 1.46, extIndex: Double = 1.0) -> Vector {

		var dirCopy = dir

		// Determine the angle from the normal
		let thetaInc = dirCopy.angleBetween(interface.normal()).radians

		// Snell's Law of reflection
		let deflection = asin((extIndex * sin(thetaInc)) / refraction)

		dirCopy.rotate(by: .radians(deflection))

		return dirCopy

	}
}

public extension RayTracable where Self: ClosedShape {
    
    /// The interface of the intersection of a ray
    /// - Parameter intersection: The point of intersection
    /// - Returns: A line representing the normal
    func interface(of intersection: Vector) -> Line {
		var entryAngle = angle(ofPoint: intersection)
        if entryAngle.radians < 0 {
			entryAngle = Angle.fullCircle + entryAngle
        }
        
		let tangentAngle = entryAngle + Angle.quarterCircle

        return Line(center: intersection, direction: tangentAngle, length: 50)
    }
    
    /// Deflect a ray according to Snell's Law
    /// - Parameter ray: The ray to deflect
    func deflectRay(_ ray: Ray) {
        let interface = self.interface(of: ray.origin)
        ray.direction = deflectionAngle(for: ray.direction, at: interface)
    }
    
    /// Calculate the critical angle of a material
    /// - Parameters:
    ///   - refraction: The refraction index of the material
    ///   - extIndex: The refraction index of the exterior material
    /// - Returns: The critical angle
    func criticalAngle(refraction: Double, extIndex: Double) -> Angle {
		return Angle.radians(asin(extIndex / refraction))
    }
}

struct Material: RayDrawable {
	let shape: RayTracable & ClosedShape

	var refraction: Double
	var extIndex: Double


	func rayIntersection(_ ray: Ray) -> Vector? {
		shape.rayIntersection(ray)
	}

	func rayIntersectionDistance(_ ray: Ray) -> Double? {
		shape.rayIntersectionDistance(ray)
	}

	func modifyRay(_ ray: Ray) {
		let interface = shape.interface(of: ray.origin)
		ray.direction = shape.deflectionAngle(for: ray.direction,
											  at: interface,
											  refraction: refraction,
											  extIndex: extIndex)
	}
}

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

extension ClosedShape where Self: RayTracable {
	public func material(refraction: Double, extIndex: Double) -> some RayDrawable {
		if var styled = self as? Material {
			styled.refraction = refraction
			styled.extIndex = extIndex
			return styled
		}

		return Material(shape: self, refraction: refraction, extIndex: extIndex)
	}
}

public enum RefractiveIndex {
	public static let vacuum: Double = 1
	public static let air: Double = 1.000293

	public static let water: Double = 1.333
	public static let oliveOil: Double = 1.47

	public static let ice: Double = 1.31
	public static let quartz: Double = 1.46
	public static let windowGlass: Double = 1.52
	public static let sapphire: Double = 1.77
	public static let diamond: Double = 2.417

}
