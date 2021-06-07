//
//  InteractiveSketch.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

/// Allows a `Sketch` to receive mouse events
public protocol InteractiveSketch {
    
    
    /// Passes a pan gesture
    /// - Parameter point: The current location of the mouse
    func mousePan(at point: Vector)
    
    
    /// Passes a click
    /// - Parameter point: The current location of the mouse
    func mouseDown(at point: Vector)
    
    
    /// Passes a scroll gesture
    /// - Parameters:
    ///   - deltaX: The horizontal delta
    ///   - deltaY: The vertical delta
    /// - Parameter point: The current location of the mouse
    func scrolled(deltaX: Double, deltaY: Double, at point: Vector)
}

/// Allows a sketch to modify SketchView behavior
public protocol SketchViewDelegate: AnyObject {
    
    /// Called just before an SVG document is generated
    /// - Parameter context: The `SVGContext` used to generate the SVG
    func willWriteToSVG(with context: SVGContext)
}
