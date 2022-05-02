//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation

/// A `Shape` that can be represented as an SVG element
public protocol SVGDrawable {
    
    /// Create a `XMLElement` representing the receiver
    func svgElement() -> XMLElement
    
    func debugSVG() -> XMLElement

}

extension SVGDrawable {
    public func debugSVG() -> XMLElement {
        svgElement()
    }
}
