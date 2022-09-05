//
//  GraphicsContext.swift
//  
//
//  Created by Emory Dunn on 9/5/22.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI
import SwiftGraphics2

@available(macOS 12.0, *)
public extension GraphicsContext {
	/// Scale and translate subsequent drawing operations to fit the sketch into the given size.
	///
	/// This method applies a translation and scale to the transformation matrix which will
	/// center the sketch inside `GraphicsContext`.
	/// - Parameters:
	///   - sketch: The Sketch to scale.
	///   - size: The size of the `Canvas`.
	mutating func fitSketch<S: Sketch>(_ body: S, in size: CGSize) {
		// Scale & translate the sketch
		let scaleW = size.width / body.size.width
		let scaleH = size.height / body.size.height

		let scale = min(scaleW, scaleH)

		let transX = (size.width - (body.size.width * scale)) / 2
		let transY = (size.height - (body.size.height * scale)) / 2

		translateBy(x: transX, y: transY)
		scaleBy(x: scale, y: scale)
	}
}
#endif

public extension CGContext {

	/// Draw a `Sketch`.
	///
	/// If the body of the Sketch conforms to `PNGDrawable` it will be drawn. If not this method does nothing.
	/// - Parameter sketch: The `Sketch` to draw.
	func draw<S: Sketch>(sketch: S) {
		switch sketch.body {
		case let shape as PNGDrawable:
			shape.draw(in: self)
		default:
			break
		}
	}
}
