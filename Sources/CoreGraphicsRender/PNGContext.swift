//
//  PNGContext.swift
//  
//
//  Created by Emory Dunn on 8/7/22.
//

import Foundation
import CoreGraphics
import SwiftGraphics2
import AppKit

/// A drawing context which creates PNG files
@resultBuilder
public class PNGContext: DrawingContext {

	static let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, 512)

	/// Width of the SVG
	public let width: Int

	/// Height of the SVG
	public let height: Int

	public var debug: Bool

//	public let image: Surface.Image

	let context: CGContext


	/// Create a new PNG with the specified dimensions
	/// - Parameters:
	///   - width: Width of the PNG
	///   - height: Height of the PNG
	init(width: Int, height: Int, debug: Bool = false) throws {

		guard width > 0 && height > 0 else {
			throw RenderError.dimensionIsZero(width: width, height: height)
		}

		self.width = width
		self.height = height
		self.debug = debug

		self.context = CGContext(data: nil,
								 width: width,
								 height: height,
								 bitsPerComponent: 8,
								 bytesPerRow: 0,
								 space: CGColorSpace(name: CGColorSpace.sRGB)!,
								 bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

		context.concatenate(PNGContext.flipVertical)

	}

	public init<C: Sketch>(_ sketch: C, debug: Bool = false) throws {
		guard sketch.size.width > 0 && sketch.size.height > 0 else {
			throw RenderError.dimensionIsZero(width: sketch.size.width, height: sketch.size.height)
		}

		self.width = Int(sketch.size.width)
		self.height = Int(sketch.size.height)
		self.debug = debug

		self.context = CGContext(data: nil,
								 width: width,
								 height: height,
								 bitsPerComponent: 8,
								 bytesPerRow: 0,
								 space: CGColorSpace(name: CGColorSpace.sRGB)!,
								 bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!


//		context.concatenate(PNGContext.flipVertical)

		addShape(sketch.sketch)

	}

	public func addShape(_ shape: Drawable) {

		switch shape {
		case let shape as PNGDrawable:
			addShape(shape)
		default:
			break
		}
	}

	/// Append a shape to the SVG
	/// - Parameter shape: Shape to add
	public func addShape(_ shape: PNGDrawable) {
		if debug {
			shape.debugDraw(in: context)
		} else {
			shape.draw(in: context)
		}
	}

	public func addShapes(_ shapes: [PNGDrawable]) {
		shapes.forEach { addShape($0) }
	}

	public func addShapes(_ shapes: PNGDrawable...) {
		shapes.forEach { addShape($0) }
	}

	public func render() throws -> Data {
		guard let image = context.makeImage() else {
			throw RenderError.failedToMakeImage
		}

		let imageRep = NSBitmapImageRep(cgImage: image)

		if let data = imageRep.representation(using: .png, properties: [:]) {
			return data
		}

		throw RenderError.failedToRenderPNGRepresentation
	}

	public func writePNG(to url: URL) throws {
		// Create the folder if needed
		try FileManager.default.createDirectory(
			at: url.deletingLastPathComponent(),
			withIntermediateDirectories: true)

		let data = try render()

		try data.write(to: url)
	}

	public func writePNG(named name: String, to directory: URL, includeSubDir: Bool = true) throws {
		var url = directory

		if includeSubDir {
			url.appendPathComponent("PNG", isDirectory: true)
		}

		url.appendPathComponent(name, isDirectory: false)

		if url.pathExtension != "png" {
			url.appendPathExtension("png")
		}

		try writePNG(to: url)

	}
}

public extension PNGContext {
	static func buildBlock(_ shapes: PNGDrawable...) -> [PNGDrawable] {
		shapes
	}
}

public extension PNGContext {
	enum RenderError: Error {
		case dimensionIsZero(width: any Numeric, height: any Numeric)
		case failedToMakeImage
		case failedToRenderPNGRepresentation
	}
}
