//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation
import SwiftGraphics2

extension BezierPath: SVGDrawable {
    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "path")

        let lines = controlPoints
            .dropFirst()
            .map{ "\($0.x),\($0.y)" }
            .joined(separator: " ")

        let command = "M \(controlPoints[0].x),\(controlPoints[0].y) C \(lines)"

        element.addAttribute(command, forKey: "d")

        element.addAttribute("black", forKey: "stroke")
        element.addAttribute("1", forKey: "stroke-width")
        element.addAttribute("none", forKey: "fill")

        return element
    }
    
    public func debugSVG() -> XMLElement {
        let path = Path(controlPoints).svgElement()
        let curve = svgElement()
        
        let element = XMLElement(name: "g")
        
        element.addChild(path)
        element.addChild(curve)
        
        return element
    }
}
