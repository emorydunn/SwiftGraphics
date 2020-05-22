//
//  Emitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Indicates an object emits rays
public protocol Emitter: RayTracer {
    
    var style: RayTraceStyle { get set }
    
    func draw(boundingBox: BoundingBox, objects: [Intersectable])
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
///
/// - `.line` draws a line between the starting and endoing points
/// - `.point` draws only the end point of a line
public enum RayTraceStyle: String, Codable, CaseIterable {
    case line, point
}

