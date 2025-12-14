//
//  Circle+Drawable.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 1/18/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import CoreGraphics

extension Circle: SVGDrawable {
    
    /// Create a `XMLElement` representing the receiver
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "circle")
        
        element.addAttribute(center.x, forKey: "cx")
        element.addAttribute(center.y, forKey: "cy")
        element.addAttribute(radius, forKey: "r")
        
        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")
        
        return element
    }
}

extension Circle: CGDrawable {
    
    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    public func draw(in context: CGContext) {
        
        context.saveGState()
        context.translateBy(x: CGFloat(-radius), y: CGFloat(-radius))
        let bb = CGRect(x: center.x, y: center.y, width: diameter, height: diameter)
        
        context.setStrokeColor(SwiftGraphicsContext.strokeColor.toCGColor())
        context.setFillColor(SwiftGraphicsContext.fillColor.toCGColor())
        context.setLineWidth(CGFloat(SwiftGraphicsContext.strokeWeight))
        context.strokeEllipse(in: bb)
        context.fillEllipse(in: bb)
        
        context.restoreGState()
    }
    
    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw(in context: CGContext) {
        draw(in: context)
    }
}
