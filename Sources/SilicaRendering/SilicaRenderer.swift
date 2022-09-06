//
//  PNGContext.swift
//  
//
//  Created by Emory Dunn on 8/7/22.
//

import Foundation
import SwiftGraphics2
import Silica
import Cairo

/// A drawing context which creates PNG files
public class SilicaRenderer {

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

	}

	public convenience init<C: Sketch>(_ sketch: C, debug: Bool = false) throws where C.Body: SIDrawable {
		try self.init(width: Int(sketch.size.width), height: Int(sketch.size.width), debug: debug)

		sketch.body.draw(in: self.context)

	}

	/// Draw a shape in the renderer's context.
	/// - Parameter shape: Shape to draw.
	public func addShape(_ shape: SIDrawable) {
		if debug {
			shape.debugDraw(in: context)
		} else {
			shape.draw(in: context)
		}
	}

	/// Draw shapes in the renderer's context.
	/// - Parameter shapes: The shape to draw.
	public func addShapes(_ shapes: [SIDrawable]) {
		shapes.forEach { addShape($0) }
	}

	/// Draw shapes in the renderer's context.
	/// - Parameter shapes: The shape to draw.
	public func addShapes(_ shapes: SIDrawable...) {
		shapes.forEach { addShape($0) }
	}

	/// Render the context to a bitmap image.
	/// - Returns: A object containing the image data.
	public func render() throws -> Data {
		try image.writePNG()
	}

	/// Write a PNG to the specified URL.
	/// - Parameter url: The location to write the data into.
	public func writePNG(to url: URL) throws {
		// Create the folder if needed
		try FileManager.default.createDirectory(
			at: url.deletingLastPathComponent(),
			withIntermediateDirectories: true)

		let data = try image.writePNG()

		try data.write(to: url)
	}

	/// Render the image and write to inside the specified directory.
	/// - Parameters:
	///   - name: The name of the file to write. The appropriate extension is added automatically if needed.
	///   - directory: The directory to save the image into.
	///   - includeSubDir: Whether or not to write the image in a format specific subdirectory.
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
