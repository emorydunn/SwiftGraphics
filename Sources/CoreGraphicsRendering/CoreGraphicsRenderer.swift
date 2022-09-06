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

/// A drawing context which creates bitmap files
public class CoreGraphicsRenderer {

	/// Width of the SVG
	public let width: Int

	/// Height of the SVG
	public let height: Int

	public var debug: Bool

	let context: CGContext

	/// Create a new PNG with the specified dimensions
	/// - Parameters:
	///   - width: Width of the PNG
	///   - height: Height of the PNG
	init(width: Int, height: Int, context: CGContext? = nil, debug: Bool = false) throws {

		guard width > 0 && height > 0 else {
			throw RenderError.dimensionIsZero(width: width, height: height)
		}

		self.width = width
		self.height = height
		self.debug = debug

		if let context {
			self.context = context
		} else {
			self.context = CGContext(data: nil,
									 width: width,
									 height: height,
									 bitsPerComponent: 8,
									 bytesPerRow: 0,
									 space: CGColorSpace(name: CGColorSpace.sRGB)!,
									 bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

			// Flip the drawing to top-left (0,0)
			self.context.concatenate(CGAffineTransformMake(1, 0, 0, -1, 0, CGFloat(height)))
		}

	}

	public convenience init<C: Sketch>(_ sketch: C, context: CGContext? = nil, debug: Bool = false) throws where C.Body: CGDrawable {
		try self.init(width: Int(sketch.size.width),
				  height: Int(sketch.size.height),
				  context: context,
				  debug: debug)

		sketch.body.draw(in: self.context)

	}

	/// Draw a shape in the renderer's context.
	/// - Parameter shape: Shape to draw.
	public func addShape(_ shape: CGDrawable) {
		if debug {
			shape.debugDraw(in: context)
		} else {
			shape.draw(in: context)
		}
	}

	/// Draw shapes in the renderer's context.
	/// - Parameter shapes: The shape to draw.
	public func addShapes(_ shapes: [CGDrawable]) {
		shapes.forEach { addShape($0) }
	}

	/// Draw shapes in the renderer's context.
	/// - Parameter shapes: The shape to draw.
	public func addShapes(_ shapes: CGDrawable...) {
		shapes.forEach { addShape($0) }
	}

	/// Render the context to a bitmap image.
	/// - Returns: A data object containing the receiver’s image data in the specified format.
	/// - Parameter storageType: The file type for the rendered image.
	public func render(using storageType: NSBitmapImageRep.FileType = .png) throws -> Data {
		guard let image = context.makeImage() else {
			throw RenderError.failedToMakeImage
		}

		let imageRep = NSBitmapImageRep(cgImage: image)

		if let data = imageRep.representation(using: storageType, properties: [:]) {
			return data
		}

		throw RenderError.failedToRenderPNGRepresentation
	}

	/// Write a PNG to the specified URL.
	/// - Parameter url: The location to write the data into.
	@available(*, deprecated, renamed: "writeImage(_:to:)")
	public func writePNG(to url: URL) throws {
		try writeImage(.png, to: url)
	}

	/// Write a PNG to the specified URL.
	/// - Parameter url: The location to write the data into.
	/// - Parameter storageType: The file type for the rendered image.
	public func writeImage(_ storageType: NSBitmapImageRep.FileType, to url: URL) throws {
		// Create the folder if needed
		try FileManager.default.createDirectory(
			at: url.deletingLastPathComponent(),
			withIntermediateDirectories: true)

		let data = try render(using: storageType)

		try data.write(to: url)
	}

	@available(*, deprecated, renamed: "writeImage(_:named:to:includeSubDir:)")
	public func writePNG(named name: String, to directory: URL, includeSubDir: Bool = true) throws {
		try writeImage(.png, named: name, to: directory, includeSubDir: includeSubDir)

	}

	/// Render the image and write to inside the specified directory.
	/// - Parameters:
	///   - storageType: The file type for the rendered image.
	///   - name: The name of the file to write. The appropriate extension is added automatically if needed.
	///   - directory: The directory to save the image into.
	///   - includeSubDir: Whether or not to write the image in a format specific subdirectory.
	public func writeImage(_ storageType: NSBitmapImageRep.FileType, named name: String, to directory: URL, includeSubDir: Bool = true) throws {
		var url = directory

		let fileExt = storageType.fileExtension

		if includeSubDir {
			url.appendPathComponent(fileExt.capitalized, isDirectory: true)
		}

		url.appendPathComponent(name, isDirectory: false)

		if url.pathExtension != fileExt {
			url.appendPathExtension(fileExt)
		}

		try writeImage(storageType, to: url)

	}
}


public extension CoreGraphicsRenderer {
	enum RenderError: Error {
		case dimensionIsZero(width: any Numeric, height: any Numeric)
		case failedToMakeImage
		case failedToRenderPNGRepresentation
	}
}
