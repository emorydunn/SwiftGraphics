//
//  File.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//

import Foundation

public typealias RayDrawable = RayTracable & Drawable

@resultBuilder
public struct RenderBuilder {

	public static func buildBlock(_ components: RayDrawable...) -> RayDrawable {
		if components.count == 1 {
			components[0]
		} else {
			RenderGroup(components)
		}
	}

	public static func buildArray(_ components: [RayDrawable]) -> RayDrawable {
		RenderGroup(components)
	}

	public static func buildEither(first component: RayDrawable) -> RayDrawable {
		component
	}

	public static func buildEither(second component: RayDrawable) -> RayDrawable {
		component
	}

	public static func buildFinalResult(_ component: RayDrawable) -> [RayDrawable] {
		switch component {
		case let e as RenderGroup:
			e.shapes
		default:
			[component]
		}
	}
}

struct RenderGroup: RayDrawable {
	func rayIntersection(_ ray: Ray) -> Vector? {
		nil
	}
	
	func rayIntersectionDistance(_ ray: Ray) -> Double? {
		nil
	}
	
	func interface(of intersection: Vector) -> Line {
		Line(0, 0, 0, 0)
	}
	
	let shapes: [RayDrawable]

	init(_ shapes: [RayDrawable]) {
		self.shapes = shapes
	}


}
