//
//  Emitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 2025-12-24.
//

import Foundation

/// An object that can calculate and draw ray intersections.
public protocol Emitter: Drawable {

    /// Visual style for the emitter's rays
    var style: RayTraceStyle { get set }

    /// Process the ray casting operations for this emitter.
    ///
    /// This method calculates the paths of the emitter's rays, but does not draw them.
    /// Any previous rays will be overwritten.
    /// - Parameter objects: The objects with which the rays will interact
    mutating func run(objects: [RayTracable])

//    /// Draw the paths taken by the emitter's rays.
//    ///
//    /// This method does not perform any ray tracing.
//	mutating func draw(in context: DrawingContext)
}

extension Emitter {
    
    /// Process the ray casting operations for this emitter and draw the paths.
    /// - Parameter objects: The objects with which the rays will interact
    public mutating func draw(objects: [RayTracable], in context: DrawingContext) {
        run(objects: objects)
        draw(in: context)
    }

    /// Draw the specified array of lines using the emitter's style
    /// - Parameter intersections: Lines to draw
    func drawIntersections(_ intersections: [Line], in context: any DrawingContext) {

        intersections.forEach {
            drawLine($0, in: context)
        }
    }

    /// Draw the specified line using the emitter's style
    /// - Parameter line: Line to draw
	func drawLine(_ line: Line, in context: any DrawingContext) {

        switch style {
        case .line:
            line.draw(in: context)
        case .point:
            line.end.draw(in: context)
        }
    }
}



/// Represents the style to draw rays
public enum RayTraceStyle: String, Codable, CaseIterable {
    
    /// draws a line between the starting and ending points
    case line
    
    /// Draws only the end point of a line
    case point
}
