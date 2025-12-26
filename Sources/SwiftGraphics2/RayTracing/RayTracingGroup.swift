//
//  RayTracingGroup.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-24.
//

import Foundation
import SwiftGraphics2

public struct RayTracingGroup: Drawable, SVGDrawable {

	public let emitters: [Emitter]
	public let shapes: [RayDrawable]

	public let drawShapes: Bool

	public init(drawShapes: Bool = true, @RenderBuilder body: () -> [RayDrawable], @EmitterBuilder emitters: () -> [Emitter]) {
		self.drawShapes = drawShapes
		self.shapes = body()
		self.emitters = emitters()
	}

	// MARK: - Drawablw
	public func draw(in context: DrawingContext) {
		shapes.forEach { context.addShape($0) }
	}

	public func svgElement() -> XMLElement? {
		let element = XMLElement(name: "g")

		// Process emitters
		for var emitter in emitters {
			print("Running \(emitter)")
			emitter.run(objects: shapes)

			if let svg = emitter.svgElement() {
				element.addChild(svg)
			}

		}

		if drawShapes {
			for shape in shapes {
				element.addChild(shape.svgElement())
			}
		}

		return element
	}

}

