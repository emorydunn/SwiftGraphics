//
//  SVGDrawable.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public protocol SVGDrawable {

    func svgElement() -> XMLElement
    
}

extension SVGDrawable {
    public func draw(in context: SVGContext) {
        context.addShape(self)
    }
}
