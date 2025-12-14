//
//  CGDrawable.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation
import CoreGraphics

/// A `Shape` that can be drawn in Core Graphics
public protocol CGDrawable: Shape {
    
    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    func draw(in context: CGContext)
    
    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    func debugDraw(in context: CGContext)
}

extension CGDrawable {
    
    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    public func debugDraw() {
        // Important: Classes that directly conform to `DrawingContext`
        // must be listed first.
        // Conformance by extension will always succeed, because the
        // method doesn't need to know anything beyond the protocol
        
        switch SwiftGraphicsContext.current {
        case is SVGContext:
            break
        case let context as CGContext:
            debugDraw(in: context)
        default:
            break
        }
        
    }
}
