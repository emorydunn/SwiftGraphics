//
//  Drawable.swift
//  
//
//  Created by Emory Dunn on 5/2/22.
//

import Foundation
//import Silica

public protocol Drawable {
//    func asShapes() -> [Shape]
    func draw(in context: DrawingContext)
}

public extension Drawable {
    func draw(in context: DrawingContext) {
        context.addShape(self)
    }
}

public struct GroupDrawable: Drawable, SVGDrawable {
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
			return shapes.first?.svgElement()
        }
        
        let element = XMLElement(name: "g")
		element.setChildren(shapes.compactMap { $0.svgElement() })

        return element
    }

//	public func draw(in context: CGContext) {
//		for case let shape as PNGDrawable in shapes {
//			shape.draw(in: context)
//		}
//	}
    
}

public struct EmptyDrawable: Drawable {
	public init() { }
}

extension EmptyDrawable: RayTracable {
	public func rayIntersection(_ ray: Ray) -> Vector? { nil }

	public func rayIntersectionDistance(_ ray: Ray) -> Double? {
		nil
	}

	public func intersections(with otherShape: any Intersectable) -> [Vector] {
		[]
	}

	public func pointOnPerimeter(_ t: Double) -> Vector {
		Vector(0, 0)
	}

	public func interface(of intersection: Vector) -> Vector {
		Vector(0, 0)
	}
}
