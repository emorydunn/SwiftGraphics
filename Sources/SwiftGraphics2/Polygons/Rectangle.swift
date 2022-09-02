//
//  Rectangle.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import simd
//import Silica

/// A rectangle defined by its center, width, and height.
public struct Rectangle: Polygon {
    
    /// The center of the rectangle
    public var origin: Vector
    
    /// The width of the rectangle
    public var width: Double
    
    /// The height of the rectangle
    public var height: Double
    
    /// The angle of rotation of the rectangle
    public var rotation: Angle

    /// The points that make up the rectangle
    public var points: [Vector] { makePolygon() }

    public init(center: Vector, width: Double, height: Double, rotation: Angle = .degrees(0)) {
        self.origin = center
        self.height = height
        self.width = width
        self.rotation = rotation
    }
    
    public init(centerX x: Double, y: Double, width: Double, height: Double, rotation: Angle = .degrees(0)) {
        self.origin = Vector(x, y)
        self.height = height
        self.width = width
        self.rotation = rotation
    }
    
    /// Calculates the points of the rectangle by applying a matrix transformation.
    ///
    /// The points start in the top left and proceed clockwise:
    /// ```
    /// +--------+
    /// |0      1|
    /// |        |
    /// |3      2|
    /// +--------+
    /// ```
    /// - Returns: An array of Vectors making up the polygon.
    public func makePolygon() -> [Vector] {
        let transMatrix = MatrixTransformation.translate(vector: origin)
        let rotMatrix = MatrixTransformation.rotate(by: rotation)
        let compoundMatrix = transMatrix * rotMatrix
        
        // Center rectangle
        return [
            Vector(-width / 2, -height / 2, transformation: compoundMatrix),
            Vector( width / 2, -height / 2, transformation: compoundMatrix),
            Vector( width / 2,  height / 2, transformation: compoundMatrix),
            Vector(-width / 2,  height / 2, transformation: compoundMatrix)
        ]


    }

}

extension Rectangle: SVGDrawable {
    public func svgElement() -> XMLElement? {
        let element = XMLElement(name: "rect")
        
        let transMatrix = MatrixTransformation.translate(vector: origin)
        let corner = Vector(-width / 2,  -height / 2, transformation: transMatrix)
        
        element.addAttribute(corner.x, forKey: "x")
        element.addAttribute(corner.y, forKey: "y")
        element.addAttribute(width, forKey: "width")
        element.addAttribute(height, forKey: "height")
        
        if rotation.degrees != 0 {
            element.addAttribute("rotate(\(rotation.degrees),\(origin.x),\(origin.y))", forKey: "transform")
        }
        
        element.strokeColor(Color.black)
        element.strokeWidth(1)
        element.fillColor(nil)

        return element
    }
}

//extension Rectangle: PNGDrawable {
//	public func draw(in context: Silica.CGContext) {
//		
//		// Create the rectangle
//		let transMatrix = MatrixTransformation.translate(vector: origin)
//		let corner = Vector(-width / 2,  -height / 2, transformation: transMatrix)
//		let rect = CGRect(x: corner.x, y: corner.y, width: width, height: height)
//
//		// Save the state and rotate
//		context.saveGState()
//		context.rotateBy(rotation.degrees)
//
//		// Draw the rect
//		context.addRect(rect)
//
//		context.strokePath()
//		context.fillPath()
//
//		// Restore the state
//		context.restoreGState()
//	}
//}
