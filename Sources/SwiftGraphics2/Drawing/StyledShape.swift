//
//  StyledShape.swift
//  
//
//  Created by Emory Dunn on 5/7/22.
//

import Foundation
import Silica

public struct StyledShape: Drawable, SVGDrawable, PNGDrawable {
    
    /// Color of the outline of the shape
    var strokeColor: Color?

    /// Color of the fill of the shape
    var fillColor: Color?

    /// Weight of the outline of the shape
    var strokeWidth: Double?
    
    var shape: Drawable
    
    init(strokeColor: Color? = nil, fillColor: Color? = nil, strokeWidth: Double? = nil, shape: Drawable) {
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
        self.shape = shape
    }
    
    public func draw(in context: DrawingContext) {
        context.addShape(self)
    }
    
    public func svgElement() -> XMLElement? {
        guard let shape = shape as? SVGDrawable else { return nil }
        
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

	public func draw(in context: Silica.CGContext) {


		context.saveGState()

		if let strokeColor {
			context.strokeColor = CGColor(strokeColor)
		}

		if let strokeWidth {
			context.lineWidth = strokeWidth
		}

		if let fillColor {
			context.fillColor = CGColor(fillColor)
		}

		if let shape = shape as? PNGDrawable {
			shape.draw(in: context)
		}


		context.restoreGState()
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
}