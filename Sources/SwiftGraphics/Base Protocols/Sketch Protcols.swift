//
//  InteractiveSketch.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

/// Allows a `Sketch` to recieve mouse events
public protocol InteractiveSketch {
    func mousePan(at point: Vector)
    func mouseDown(at point: Vector)
    func scrolled(deltaX: Double, deltaY: Double, at point: Vector)
}

/// Allows a sketch to modify SketchView behavior
public protocol SketchViewDelegate {
    func willWriteToSVG(with context: SVGContext)
}
