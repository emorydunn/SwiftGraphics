//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/2/22.
//

import Foundation
import Silica

public protocol Drawable {
//    func asShapes() -> [Shape]
    func draw(in context: DrawingContext)
}

public extension Drawable {
    func draw(in context: DrawingContext) {
        context.addShape(self)
    }
}

public struct GroupDrawable: Drawable, SVGDrawable, PNGDrawable {
    public let shapes: [Drawable]

    public init(_ shapes: [Drawable]) {
        self.shapes = shapes
    }
    
    public init(@SketchBuilder _ builder: () -> Drawable) {
        self.shapes = [builder()]
    }
    
    public func draw(in context: DrawingContext) {
        shapes.forEach { context.addShape($0) }
    }
    
    public func svgElement() -> XMLElement? {
        // Break single element groups
        guard shapes.count > 1 else {
            return (shapes[0] as? SVGDrawable)?.svgElement()
        }
        
        let element = XMLElement(name: "g")
        element.setChildren(shapes.compactMap { ($0 as? SVGDrawable)?.svgElement() })
        
        return element
    }

	public func draw(in context: CGContext) {
		for case let shape as PNGDrawable in shapes {
			shape.draw(in: context)
		}
	}
    
}

public struct EmptyDrawable: Drawable {
    public init() { }
}

//extension Array: Drawable where Element: Drawable {
//    public func draw(in context: DrawingContext) {
//        forEach {
//            context.addShape($0)
//        }
//    }
//}

//public protocol Drawable {
//    func asShapes() -> [Shape]
//}
//
//
//extension Array: Drawable where Element: Drawable {
//    public func asShapes() -> [Shape] { self.flatMap { $0.asShapes() } }
//}
//
//struct StyledShape: Drawable {
//
//    /// Color of the outline of the shape
//    var strokeColor: Color?
//
//    /// Color of the fill of the shape
//    var fillColor: Color?
//
//    /// Weight of the outline of the shape
//    var strokeWidth: Double?
//
//    var shape: Drawable
//
//    init(strokeColor: Color? = nil, fillColor: Color? = nil, strokeWidth: Double? = nil, shape: Drawable) {
//        self.strokeColor = strokeColor
//        self.fillColor = fillColor
//        self.strokeWidth = strokeWidth
//        self.shape = shape
//    }
//
//    public func asShapes() -> [Shape] { [shape as! Shape] }
//
//
//}

/// Shapes that can be drawn on screen
//public protocol Drawable {
//    /// Color of the outline of the shape
//    var strokeColor: Color?  { get set }
//
//    /// Color of the fill of the shape
//    var fillColor: Color? { get set }
//
//    /// Weight of the outline of the shape
//    var strokeWidth: Double? { get set }
//}

//public extension Drawable {
//    func strokeColor(_ color: Color?) -> Self {
//        var new = self
//        new.strokeColor = color
//
//        return new
//    }
//
//    func fillColor(_ color: Color?) -> Self {
//        var new = self
//        new.fillColor = color
//
//        return new
//    }
//
//    func strokeWidth(_ weight: Double?) -> Self {
//        var new = self
//        new.strokeWidth = weight
//
//        return new
//    }
//}
//
//public extension Array where Element: Drawable {
//    func strokeColor(_ color: Color?) -> Self {
//        map { $0.strokeColor(color) }
//    }
//
//    func fillColor(_ color: Color?) -> Self {
//        map { $0.fillColor(color) }
//    }
//
//    func strokeWidth(_ weight: Double?) -> Self {
//        map { $0.strokeWidth(weight) }
//    }
//}
