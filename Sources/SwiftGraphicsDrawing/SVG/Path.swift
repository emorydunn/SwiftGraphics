//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation
import SwiftGraphics2

extension Path: SVGDrawable {
    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "polyline")

        element.addAttribute(points.map { "\($0.x),\($0.y)" }.joined(separator: " "),
                             forKey: "points")

        element.addAttribute("black", forKey: "stroke")
        element.addAttribute("1", forKey: "stroke-width")
        element.addAttribute("none", forKey: "fill")

        return element
    }
}

