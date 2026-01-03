//
//  Material.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-29.
//
import Foundation

struct Material: RayDrawable {
	let shape: RayTracable

	var refraction: Double

	func rayIntersection(_ ray: Ray) -> Vector? {
		shape.rayIntersection(ray)
	}

	func rayIntersectionDistance(_ ray: Ray) -> Double? {
		shape.rayIntersectionDistance(ray)
	}

	func interface(of intersection: Vector) -> Vector {
		shape.interface(of: intersection)
	}

	func modifyRay(_ ray: Ray) {
		// If the ray's index matches the material
		// then the ray is "inside" the material
		// and we need to exit
		// Otherwise the ray is entering the material
		let index1: Double
		let index2: Double

		var interface = shape.interface(of: ray.origin)

		if ray.materialIndex == refraction {
			index1 = ray.materialIndex
			index2 = ray.previousIndex
		} else {
			index1 = ray.materialIndex
			index2 = refraction
		}

		// Ensure the normal is in the same direction as the ray
		if ray.direction.isBehind(interface) {
			interface = interface.rotated(by: .pi)
		}

		// Add debug normal line
		ray.interfaces.append(Line(origin: ray.origin, direction: interface, length: 50))

		let newDir: Angle = shape.deflectionAngle(for: ray,
												  at: interface,
												  index1: index1,
												  index2: index2)

		ray.direction.rotate(to: newDir)
		ray.previousIndex = ray.materialIndex
		ray.materialIndex = refraction
	}
}

extension Shape where Self: RayTracable {
	public func material(refraction: Double) -> some RayDrawable {
		if var styled = self as? Material {
			styled.refraction = refraction
			return styled
		}

		return Material(shape: self, refraction: refraction)
	}
}

extension Double {
	public enum refractiveIndex {

		/// Index of Refraction of Vacuum.
		///
		/// `IoR = 1`
		public static let vacuum: Double = 1

		/// Index of Refraction of Air.
		///
		/// `IoR = 1.000293`
		public static let air: Double = 1.000293

		/// Index of Refraction of Water.
		///
		/// `IoR = 1.333`
		public static let water: Double = 1.333

		/// Index of Refraction of Olive Oil.
		///
		/// `IoR = 1.47`
		public static let oliveOil: Double = 1.47

		/// Index of Refraction of Ice.
		///
		/// `IoR = 1.31`
		public static let ice: Double = 1.31

		/// Index of Refraction of Quartz.
		///
		/// `IoR = 1.46`
		public static let quartz: Double = 1.46

		/// Index of Refraction of Window Glass.
		///
		/// `IoR = 1.52`
		public static let windowGlass: Double = 1.52

		/// Index of Refraction of Sapphire.
		///
		/// `IoR = 1.77`
		public static let sapphire: Double = 1.77

		/// Index of Refraction of Diamond.
		///
		/// `IoR = 2.417`
		public static let diamond: Double = 2.417
	}

}
