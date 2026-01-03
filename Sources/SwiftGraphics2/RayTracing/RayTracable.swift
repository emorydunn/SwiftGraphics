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

	func interface(of intersection: Vector) -> Line
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

		// Determine the angle from the normal
		let thetaInc = dir.angleBetween(interface.normal()).radians

		// Snell's Law of reflection
		let deflection = asin((extIndex * sin(thetaInc)) / refraction)

		return dir.rotated(by: .radians(deflection))
	}

	/// Calculate the angle of deflection using Snell's Law of Reflection
	/// - Parameters:
	///   - dir: The angle of intersection
	///   - interface: The interface
	///   - refraction: The refraction index of the material
	///   - extIndex: The refraction index of the exterior material
	/// - Returns: A `Vector` rotated by the angle of reflection
	func deflectionAngle(for dir: Vector, at interface: Line, index1: Double, index2: Double) -> Vector {

		// Determine the angle from the normal
		let thetaInc = dir.angleBetween(interface.normal()).radians

		// Snell's Law of reflection
		let deflection = asin((index1 / index2) * sin(thetaInc))

		return dir.rotated(by: .radians(deflection))
	}

	/// Calculate the angle of deflection using Snell's Law of Reflection
	/// - Parameters:
	///   - dir: The angle of intersection
	///   - interface: The interface
	///   - refraction: The refraction index of the material
	///   - extIndex: The refraction index of the exterior material
	/// - Returns: A `Vector` rotated by the angle of reflection
	func deflectionAngle(for ray: Ray, at interface: Vector, index1: Double, index2: Double) -> Vector {
		let directionNormalized = ray.direction

		let relativeIOR = index1 / index2
		let cosAngleIn = -(directionNormalized * interface)
		let sinSqrAngle = relativeIOR.squared() * (1 - cosAngleIn.squared())

		// If the angle is greater than 1 we're above the
		// critical angle and need to reflect.
		guard sinSqrAngle <= 1 else {
			return directionNormalized + 2 * cosAngleIn * interface
		}

		return directionNormalized * relativeIOR + interface * (relativeIOR * cosAngleIn - sqrt(1 - sinSqrAngle))
	}

	/// Calculate the angle of deflection using Snell's Law of Reflection
	/// - Parameters:
	///   - dir: The angle of intersection
	///   - interface: The interface
	///   - refraction: The refraction index of the material
	///   - extIndex: The refraction index of the exterior material
	/// - Returns: A `Vector` rotated by the angle of reflection
	func deflectionAngle(for ray: Ray, at interface: Line, index1: Double, index2: Double) -> Angle {
		deflectionAngle(for: ray, at: interface, index1: index1, index2: index2).heading()
	}

	func criticalAngle(for dir: Vector, at interface: Line, index1: Double, index2: Double) -> Angle {
		let thetaCrit = asin(index2 / index1)

		return .radians(thetaCrit)
	}
	
	/// Calculate the ratio of light reflected versus transmitted through an interface.
	///
	/// The higher the returned value the more light is reflected versus transmitted.
	///
	/// Adapted from _Reflections and Refractions in Ray Tracing_ by Bram de Greve.
	/// - Parameters:
	///   - ray: The `Ray` to test.
	///   - interface: The normal of the interface.
	///   - index1: The index of refraction of the material the `Ray` is in.
	///   - index2: The index of refraction of the material to which the `Ray` is moving.
	/// - Returns: The ratio of transmitted light, from `0...1`.
	func reflectance(for ray: Ray, at interface: Vector, index1: Double, index2: Double) -> Double {
		let ratio = index1 / index2
		let cosIn = -(ray.direction * interface)
		let sinSquareRefract = ratio * ratio * (1 - cosIn * cosIn)

		guard sinSquareRefract < 1 else { return 1 }

		let cosRefract = sqrt(1 - sinSquareRefract)
		let sqrtRayPerp = (index1 * cosIn - index2 * cosRefract) / (index1 * cosIn + index2 * cosRefract)
		let sqrtRayParallel = (index2 * cosIn - index1 * cosRefract) / (index2 * cosIn + index1 * cosRefract)

		return (sqrtRayPerp * sqrtRayPerp + sqrtRayParallel * sqrtRayParallel) / 2
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

		let interface = Line(center: intersection, direction: tangentAngle, length: 50)

		if intersection.isBehind(line: interface) {
			return interface
		} else {
			return interface.pointsSwitched()
		}
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

