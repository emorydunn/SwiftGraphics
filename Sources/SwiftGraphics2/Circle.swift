//
//  Circle.swift
//  
//
//  Created by Emory Dunn on 10/13/21.
//

import Foundation

public struct Circle: Drawable {
    /// Radius of the circle
    public var radius: Double

    /// Center point of the circle
    public var center: Vector

    /// The diameter of the circle
    public var diameter: Double { radius * 2 }
    
    /// Color of the outline of the shape
    public var strokeColor: Color?
    
    /// Color of the fill of the shape
    public var fillColor: Color?
    
    /// Weight of the outline of the shape
    public var strokeWidth: Double?

    /// Instantiate a new `Circle`
    /// - Parameters:
    ///   - center: Center of the circle
    ///   - radius: Radius of the circle
    public init(center: Vector, radius: Double) {
        self.center = center
        self.radius = radius
    }

    /// Instantiate a new `Circle`
    /// - Parameters:
    ///   - x: Center X coordinate
    ///   - y: Center Y coordinate
    ///   - radius: Radius of the circle
    public init(x: Double, y: Double, radius: Double) {
        self.init(center: Vector(x, y), radius: radius)

    }

    /// A Rectangle that contains the receiver
    public var boundingBox: Rectangle {
        Rectangle(center: center, width: diameter, height: diameter)
    }
}

extension Circle: SVGDrawable {
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "circle")
        
        element.addAttribute(center.x, forKey: "cx")
        element.addAttribute(center.y, forKey: "cy")
        element.addAttribute(radius, forKey: "r")
        
        element.strokeColor(strokeColor)
        element.strokeWidth(strokeWidth)
        element.fillColor(fillColor)
        
        return element
    }
}
