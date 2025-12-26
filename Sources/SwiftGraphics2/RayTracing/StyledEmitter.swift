//
//  StyledEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-25.
//
import Foundation

public struct StyledEmitter: Emitter, Drawable, SVGDrawable {

	/// Color of the outline of the shape
	public var strokeColor: Color?

	/// Color of the fill of the shape
	public var fillColor: Color?

	/// Weight of the outline of the shape
	public var strokeWidth: Double?

	public var shape: Emitter

	public var style: RayTraceStyle {
		get { shape.style }
		set { shape.style = newValue }
	}

	init(strokeColor: Color? = nil, fillColor: Color? = nil, strokeWidth: Double? = nil, style: RayTraceStyle = .line, shape: Emitter) {
		self.strokeColor = strokeColor
		self.fillColor = fillColor
		self.strokeWidth = strokeWidth
		self.shape = shape
	}

	public func draw(in context: DrawingContext) {
		context.addShape(self)
	}

	public func svgElement() -> XMLElement? {
		guard let shape = shape as? SVGDrawable else {
			return nil
		}

		let element = shape.svgElement()

		// If there are no children apply the style directly the the node
		guard let children = element?.children else {
			element?.strokeColor(strokeColor)
			element?.strokeWidth(strokeWidth)
			element?.fillColor(fillColor)

			return element
		}

		// If the node has children, such as a group, override the style
		for case let child as XMLElement in children {
			child.strokeColor(strokeColor)
			child.strokeWidth(strokeWidth)
			child.fillColor(fillColor)
		}

		return element
	}

	public mutating func run(objects: [RayTracable]) {
		shape.run(objects: objects)
	}

}

public extension Emitter {
    func strokeColor(_ color: Color?) -> some Emitter {
        if var styled = self as? StyledEmitter {
            styled.strokeColor = color
            return styled
        }
        
        return StyledEmitter(strokeColor: color, shape: self)
    }

    func fillColor(_ color: Color?) -> some Emitter {
        if var styled = self as? StyledEmitter {
            styled.fillColor = color
            return styled
        }
        
        return StyledEmitter(fillColor: color, shape: self)
    }

    func strokeWidth(_ weight: Double?) -> some Emitter {
        if var styled = self as? StyledEmitter {
            styled.strokeWidth = weight
            return styled
        }
        
        return StyledEmitter(strokeWidth: weight, shape: self)
    }

	func rayStyle(_ style: RayTraceStyle) -> some Emitter {
		if var styled = self as? StyledEmitter {
			styled.style = style
			return styled
		}

		return StyledEmitter(style: style, shape: self)
	}
}
