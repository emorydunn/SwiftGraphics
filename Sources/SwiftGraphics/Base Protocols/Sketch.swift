//
//  Sketch.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import AppKit

/// An object which can draw shapes to a `DrawingContext`
public protocol Sketch {
    
    /// Title of the sketch
    static var title: String { get set }

    /// Size of the sketch
    var size: Size { get set }
    
    /// Whether to repeatedly call `.draw()`
    var loop: SketchAnimation { get set }

    /// Instantiate a new sketch
    init()

    /// Draw all objects to the current `DrawingContext`
    func draw()

}

/// Controls `Sketch` animation
public enum SketchAnimation {
    
    /// Only call `.draw()` once
    case none
    
    /// Repeatedly call `.draw()` at the specified framerate
    case animate(frameRate: Int)
    
    /// The amount of time each frame takes
    /// - Parameter frameRate: The framerate.
    /// - Returns: The number of seconds each frame takes.
    public func frameRateInterval(_ frameRate: Int) -> TimeInterval {
        return 1 / Double(frameRate)
    }
}

extension Sketch {

    /// Returns the current `DrawingContext`
    public var context: DrawingContext? {
        SwiftGraphicsContext.current
    }

    /// Return a unique file name based on a hash of the time and pid.
    ///
    /// The string takes the form of `YYYYMMDD-HHmmss-<short hash>`
    public func hashedFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"

        let dateString = formatter.string(from: Date())

        let hash = "\(getpid())-\(dateString)".sha1()
        let shortHash = String(hash.dropLast(hash.count - 8))

        getpid()
        let fileName = "\(dateString)-\(shortHash)"

        return fileName
    }

    /// Draw a solid rectangle over the sketch
    /// - Parameter fillColor: Color of the background to draw
    /// - Parameter drawInSVG: Draw the background in `SVGContext`
    public func drawBackground(fillColor: Color = .white, drawInSVG: Bool = false) {

        switch SwiftGraphicsContext.current {
        case is SVGContext:
            if drawInSVG {
                fallthrough
            }
        case is CGContext:
            SwiftGraphicsContext.fillColor = fillColor
            SwiftGraphicsContext.strokeColor = .clear

            BoundingBox(inset: 0).draw()
        default:
            break
        }

    }

}
