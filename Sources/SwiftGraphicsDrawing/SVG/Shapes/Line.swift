//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation
import SwiftGraphics2

extension Line: SVGDrawable {
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "line")
        
        element.addAttribute(start.x, forKey: "x1")
        element.addAttribute(start.y, forKey: "y1")
        element.addAttribute(end.x, forKey: "x2")
        element.addAttribute(end.y, forKey: "y2")

        element.addAttribute("black", forKey: "stroke")
        element.addAttribute("1", forKey: "stroke-width")

        return element
    }
}
