//
//  DrawingContext.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public class SwiftGraphicsContext {
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

public protocol DrawingContext {

}

extension CGContext: DrawingContext {

}
