//
//  CGDrawable.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

/// A `Shape` that can be drawn in Core Graphics
public protocol CGDrawable: Shape {
    
    /// Draw the receiver in the specified context
    /// - Parameter context: Context in which to draw
    func draw(in context: CGContext)
    
    /// Draw a representation of the receiver meant for debugging the shape in the specified context
    /// - Parameter context: Context in which to draw
    func debugDraw(in context: CGContext)
}
