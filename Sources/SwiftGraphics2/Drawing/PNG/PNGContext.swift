//
//  PNGContext.swift
//  
//
//  Created by Emory Dunn on 8/7/22.
//

import Foundation
import Silica
import Cairo

/// A drawing context which creates SVG files
@resultBuilder
public class PNGContext: DrawingContext {

	/// Width of the SVG
	public let width: Int

	/// Height of the SVG
	public let height: Int

	public var debug: Bool

	public let image: Surface.Image

	let context: CGContext


	/// Create a new PNG with the specified dimensions
	/// - Parameters:
	///   - width: Width of the PNG
	///   - height: Height of the PNG
	init(width: Int, height: Int, debug: Bool = false) throws {
		self.width = width
		self.height = height
		self.debug = debug

		self.image = try Surface.Image(format: ImageFormat.argb32, width: width, height: height)
		self.context = try Silica.CGContext(surface: image, size: CGSize(width: width, height: height))

//		self.image = CGImage(width: width,
//							 height: height,
//							 bitsPerComponent: 8,
//							 bitsPerPixel: 24,
//							 bytesPerRow: <#T##Int#>,
//							 space: CGColorSpace.adobeRGB1998,
//							 bitmapInfo: [CGBitmapInfo.byteOrderDefault],
//							 provider: <#T##CGDataProvider#>,
//							 decode: <#T##CGFloat?#>,
//							 shouldInterpolate: <#T##Bool#>,
//							 intent: <#T##CGColorRenderingIntent#>)
//		image.lockFocusFlipped(true)
	}

	public init<C: Sketch>(_ sketch: C, debug: Bool = false) throws {
		self.width = Int(sketch.size.width)
		self.height = Int(sketch.size.height)
		self.debug = debug

		self.image = try Surface.Image(format: ImageFormat.argb32, width: width, height: height)
		self.context = try Silica.CGContext(surface: image, size: CGSize(width: width, height: height))

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
		try image.writePNG()
	}

	public func writePNG(to url: URL) throws {
		// Create the folder if needed
		try FileManager.default.createDirectory(
			at: url.deletingLastPathComponent(),
			withIntermediateDirectories: true)

		let data = try image.writePNG()

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
