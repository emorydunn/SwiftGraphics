//
//  CGDrawable.swift
//  
//
//  Created by Emory Dunn on 8/7/22.
//

import Foundation
import CoreGraphics
import SwiftGraphics2

/// A `Shape` that can be represented as an PNG element
public protocol CGDrawable: Drawable {

	/// Draw the receiver in the specified context
	/// - Parameter context: Context in which to draw
	func draw(in context: CGContext)

	/// Draw a representation of the receiver meant for debugging the shape in the specified context
	/// - Parameter context: Context in which to draw
	func debugDraw(in context: CGContext)

}

extension CGDrawable {
	public func debugDraw(in context: CGContext) {
		draw(in: context)
	}
}

extension Drawable {
	/// Draw the receiver in the specified context
	/// - Parameter context: Context in which to draw
	func draw(in context: CGContext) {
		if let drawable = self as? CGDrawable {
			drawable.draw(in: context)
		}
	}

	/// Draw a representation of the receiver meant for debugging the shape in the specified context
	/// - Parameter context: Context in which to draw
	func debugDraw(in context: CGContext) {
		
	}
}
