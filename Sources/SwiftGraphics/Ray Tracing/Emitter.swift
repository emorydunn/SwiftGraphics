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

    /// Draw the emitter and ray trace using the specified objects
    /// - Parameters:
    ///   - objects: Objects to test for intersection when casting rays
    func draw(objects: [Intersectable])
}

extension Emitter {

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
