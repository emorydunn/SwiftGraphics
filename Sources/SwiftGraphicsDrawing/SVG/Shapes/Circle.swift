//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation
import SwiftGraphics2

extension Circle: SVGDrawable {
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "circle")
        
        element.addAttribute(center.x, forKey: "cx")
        element.addAttribute(center.y, forKey: "cy")
        element.addAttribute(radius, forKey: "r")
        
        element.addAttribute("black", forKey: "stroke")
        element.addAttribute("1", forKey: "stroke-width")
        element.addAttribute("none", forKey: "fill")
        
        return element
    }
}
