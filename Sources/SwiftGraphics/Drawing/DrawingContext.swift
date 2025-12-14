//
//  DrawingContext.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation
import CoreGraphics

/// Holds values related to how objects should be drawn
public class SwiftGraphicsContext {
    
    /// Returns the current `DrawingContext`, if any
    public static var current: DrawingContext?

    /// Color of the outline of the shape
    public static var strokeColor: Color = .black

    /// Color of the fill of the shape
    public static var fillColor: Color = .clear

    /// Weight of the outline of the shape
    public static var strokeWeight: Double = 1

    /// Color blending mode
    public static var blendMode: BlendMode = .normal

}

/// A 2D drawing environment
public protocol DrawingContext {

}

extension CGContext: DrawingContext {

}
