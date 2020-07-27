//
//  SVGDrawable.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

/// A `Shape` that can be represented as an SVG element
public protocol SVGDrawable {
    
    /// Create a `XMLElement` representing the receiver
    func svgElement() -> XMLElement

}

extension SVGDrawable {
    
    /// Add the receiver to the specified cotext
    public func draw(in context: SVGContext) {
        context.addShape(self)
    }
    
}
