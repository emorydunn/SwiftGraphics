//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation
import SwiftGraphics2

extension Rectangle: SVGDrawable {
    public func svgElement() -> XMLElement {
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
//

//        element.addAttribute(SwiftGraphicsContext.strokeColor, forKey: "stroke")
//        element.addAttribute(SwiftGraphicsContext.strokeWeight, forKey: "stroke-width")
//        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
    }
}
