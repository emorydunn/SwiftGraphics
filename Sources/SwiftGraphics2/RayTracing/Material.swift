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
	var extIndex: Double

	func rayIntersection(_ ray: Ray) -> Vector? {
		shape.rayIntersection(ray)
	}

	func rayIntersectionDistance(_ ray: Ray) -> Double? {
		shape.rayIntersectionDistance(ray)
	}

	func interface(of intersection: Vector) -> Line {
		shape.interface(of: intersection)
	}

	func modifyRay(_ ray: Ray) {
		let interface = shape.interface(of: ray.origin.normalized())

		// If the ray's index matches the material
		// then the ray is "inside" the material
		// and we need to exit
		// Otherwise the ray is entering the material
		let index1: Double
		let index2: Double

		if ray.materialIndex == refraction {
			index1 = ray.materialIndex
			index2 = ray.previousIndex
		} else {
			index1 = ray.materialIndex
			index2 = refraction
		}

		print("Ray is moving from \(index1) to \(index2) at \(ray.direction.heading())")
		let newDir: Angle = shape.deflectionAngle(for: ray.direction,
												  at: interface,
												  index1: index1,
												  index2: index2)

		ray.direction.rotate(to: newDir)

		ray.previousIndex = ray.materialIndex
		ray.materialIndex = refraction

	}
}



extension Shape where Self: RayTracable {
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
