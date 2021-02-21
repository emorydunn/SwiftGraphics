//
//  Emitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An object that can calculate and draw ray intersections.
public protocol Emitter: AnyObject {

    /// Visual style for the emitter's rays
    var style: RayTraceStyle { get set }

    /// Process the ray casting operations for this emitter.
    ///
    /// This method calculates the paths of the emitter's rays, but does not draw them.
    /// Any previous rays will be overwritten.
    /// - Parameter objects: The objects with which the rays will interact
    func run(objects: [RayTracable])
    
    /// Draw the paths taken by the emitter's rays.
    ///
    /// This method does not perform any ray tracing.
    func draw()
}

extension Emitter {
    
    /// Process the ray casting operations for this emitter and draw th paths.
    /// - Parameter objects: The objects with which the rays will interact
    public func draw(objects: [RayTracable]) {
        run(objects: objects)
        draw()
    }

    /// Draw the specified array of lines using the emitter's style
    /// - Parameter intersections: Lines to draw
    func drawIntersections(_ intersections: [Line]) {

        intersections.forEach {
            drawLine($0)
        }
    }

    /// Draw the specified line using the emitter's style
    /// - Parameter line: Line to draw
    func drawLine(_ line: Line) {

        switch style {
        case .line:
            line.draw()
        case .point:
            line.end.draw()
        }
    }
}

/// Represnts the style to draw rays
public enum RayTraceStyle: String, Codable, CaseIterable {
    
    /// draws a line between the starting and endoing points
    case line
    
    /// Draws only the end point of a line
    case point
}
