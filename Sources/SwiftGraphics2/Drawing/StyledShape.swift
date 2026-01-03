//
//  StyledShape.swift
//
//
//  Created by Emory Dunn on 5/7/22.
//

import Foundation

public struct StyledShape: Drawable, SVGDrawable {

	/// Color of the outline of the shape
	public var strokeColor: Color?

	/// Color of the fill of the shape
	public var fillColor: Color?

	/// Weight of the outline of the shape
	public var strokeWidth: Double?

	public var shape: Drawable

	public var blendMode: BlendMode

	init(strokeColor: Color? = nil, fillColor: Color? = nil, strokeWidth: Double? = nil, blendMode: BlendMode = .normal, shape: Drawable) {
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		self.strokeWidth = strokeWidth
		self.shape = shape
		self.blendMode = blendMode
	}

	public func draw(in context: DrawingContext) {
		context.addShape(self)
	}

	public func svgElement() -> XMLElement? {
		guard let shape = shape as? SVGDrawable else { return nil }

		let element = shape.svgElement()

		guard element?.isDebugElement == false else { return element }

		// If there are no children apply the style directly the the node
		guard let children = element?.children else {
			element?.strokeColor(strokeColor)
			element?.strokeWidth(strokeWidth)
			element?.fillColor(fillColor)
			element?.addAttribute("mix-blend-mode: \(blendMode);", forKey: "style")

			return element
		}

		// If the node has children, such as a group, override the style
		for case let child as XMLElement in children {
			guard child.isDebugElement == false else { continue }

			child.strokeColor(strokeColor)
			child.strokeWidth(strokeWidth)
			child.fillColor(fillColor)
			child.addAttribute("mix-blend-mode: \(blendMode);", forKey: "style")
		}

		return element
	}

}

public extension Drawable {
	func strokeColor(_ color: Color?) -> some Drawable {
		if var styled = self as? StyledShape {
			styled.strokeColor = color
			return styled
		}

		return StyledShape(strokeColor: color, shape: self)
	}

	func fillColor(_ color: Color?) -> some Drawable {
		if var styled = self as? StyledShape {
			styled.fillColor = color
			return styled
		}

		return StyledShape(fillColor: color, shape: self)
	}

	func strokeWidth(_ weight: Double?) -> some Drawable {
		if var styled = self as? StyledShape {
			styled.strokeWidth = weight
			return styled
		}

		return StyledShape(strokeWidth: weight, shape: self)
	}

	func blendMode(_ blendMode: BlendMode) -> some Drawable {
		if var styled = self as? StyledShape {
			styled.blendMode = blendMode
			return styled
		}
		
		return StyledShape(blendMode: blendMode, shape: self)
	}
}
