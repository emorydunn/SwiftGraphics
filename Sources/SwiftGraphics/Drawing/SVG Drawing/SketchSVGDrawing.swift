//
//  SketchSVGDrawing.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 4/15/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

public extension Sketch {
    /// Creates an SVG document
    func drawToSVG() -> XMLDocument? {
        let context = SVGContext(sketch: self)
        
        SwiftGraphicsContext.current = context
        
        draw()
        
        (self as? SketchViewDelegate)?.willWriteToSVG(with: context)
        let doc = context.makeDoc()
        
        return doc
    }
    
    
    /// Generates an SVG and attempts to write it to the specified URL
    /// - Parameter url: URL to write to
    func saveSVG(to url: URL) throws {
        let context = SVGContext(sketch: self)
        
        SwiftGraphicsContext.current = context
        
        draw()
        
        (self as? SketchViewDelegate)?.willWriteToSVG(with: context)
        
        try context.writeSVG(to: url)
        
    }
}
