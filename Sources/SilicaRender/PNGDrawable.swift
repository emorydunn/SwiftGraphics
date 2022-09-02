//
//  PNGDrawable.swift
//  
//
//  Created by Emory Dunn on 8/7/22.
//

import Foundation
import Silica
import SwiftGraphics2

/// A `Shape` that can be represented as an SVG element
public protocol PNGDrawable: Drawable {

	/// Draw the receiver in the specified context
	/// - Parameter context: Context in which to draw
	func draw(in context: Silica.CGContext)

	/// Draw a representation of the receiver meant for debugging the shape in the specified context
	/// - Parameter context: Context in which to draw
	func debugDraw(in context: Silica.CGContext)

}

extension PNGDrawable {
	public func debugDraw(in context: Silica.CGContext) {
		draw(in: context)
	}
}
