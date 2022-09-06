//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation

/// A `Shape` that can be represented as an SVG element
public protocol SVGDrawable: Drawable {
    
    /// Create a `XMLElement` representing the receiver
    func svgElement() -> XMLElement?
    
    func debugSVG() -> XMLElement?

}

extension SVGDrawable {
    public func debugSVG() -> XMLElement? {
        svgElement()
    }
}

extension Drawable {
	/// Draw the receiver in the specified context
	/// - Parameter context: Context in which to draw
	func svgElement() -> XMLElement? {
		if let drawable = self as? SVGDrawable {
			return drawable.svgElement()
		}
		return nil
	}

	/// Draw a representation of the receiver meant for debugging the shape in the specified context
	/// - Parameter context: Context in which to draw
	func debugSVG() -> XMLElement? {
		if let drawable = self as? SVGDrawable {
			return drawable.debugSVG()
		}
		return nil
	}
}
