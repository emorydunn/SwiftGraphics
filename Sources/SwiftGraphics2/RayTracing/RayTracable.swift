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
	func deflectionAngle(for dir: Vector, at interface: Line, index1: Double, index2: Double) -> Angle {
		let normal = interface.normal()

		// Determine the angle from the normal
		let theta1 = dir.angleBetween(normal)

		let sinAngle = (index1 / index2) * sin(theta1.radians)

		// If the sin(theta2) is less than 1 we're below the critical angle
		// and achieve total internal reflection.
		guard abs(sinAngle) < 1 else {
			return Vector(angle: theta1).reflected(across: interface).heading() + 90
		}

		let deflectionAngle = Angle(radians: asin(sinAngle))

		return interface.normal().heading() + deflectionAngle
	}

	func criticalAngle(for dir: Vector, at interface: Line, index1: Double, index2: Double) -> Angle {
		let thetaCrit = asin(index2 / index1)

		return .radians(thetaCrit)
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

