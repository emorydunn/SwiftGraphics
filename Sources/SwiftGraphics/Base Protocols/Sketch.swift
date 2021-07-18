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
    
    /// Repeatedly call `.draw()` at the specified frame-rate
    case animate(frameRate: Int)
    
    /// The amount of time each frame takes
    /// - Parameter frameRate: The frame-rate.
    /// - Returns: The number of seconds each frame takes.
    public func frameRateInterval(_ frameRate: Int) -> TimeInterval {
        return 1 / Double(frameRate)
    }
}

public extension Sketch {

    /// Returns the current `DrawingContext`
    var context: DrawingContext? {
        SwiftGraphicsContext.current
    }

    /// Return a unique file name based on a hash of the time and pid.
    ///
    /// The string takes the form of `YYYYMMDD-HHmmss-<short hash>`
    func hashedFileName(dateFormat: String = "yyyyMMdd-HHmmss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

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
    func drawBackground(fillColor: Color = .white, drawInSVG: Bool = false) {

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
    
    /// The Output folder relative to the current file.
    ///
    /// `#filePath/../../../Output/`
    func outputFolder(relativeTo url: URL = URL(fileURLWithPath: #filePath)) -> URL {
        let rootPath = url
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
        return rootPath.appendingPathComponent("Output")
    }
    
    /// Render the sketch to an output folder relative to the `#filePath`.
    ///
    /// This method is primarily meant for SPM-based sketches. The SVG is saved to
    /// `#filePath/../../../Output/SVG`
    ///
    /// - Throws: Any errors while writing the renders to disk.
    /// - Returns: The URL of the SVG.
    func writeSVGToOutput(_ filename: String, output: URL) throws -> URL {
        let rootPath = output.appendingPathComponent("SVG")

        try FileManager.default.createDirectory(at: rootPath, withIntermediateDirectories: true)
        
        let svgURL = rootPath.appendingPathComponent("\(filename).svg")
        try saveSVG(to: svgURL)
        
        return svgURL
    }
    
    /// Render the sketch to an output folder relative to the `#filePath`.
    ///
    /// This method is primarily meant for SPM-based sketches. The PNG is saved to
    /// `#filePath/../../../Output/PNG`
    ///
    /// - Throws: Any errors while writing the renders to disk.
    /// - Returns: The URL of the PNG.
    func writePNGToOutput(_ filename: String, output: URL) throws -> URL {
        let rootPath = output.appendingPathComponent("PNG")
        
        try FileManager.default.createDirectory(at: rootPath, withIntermediateDirectories: true)
        
        let pngURL = rootPath.appendingPathComponent("\(filename).png")
        try saveImage(to: pngURL)
        
        return pngURL
    }
    
    /// Render the sketch to an output folder relative to the `#filePath`.
    ///
    /// This method is primarily meant for SPM-based sketches. The files is saved to
    /// `#filePath/../../../Output`
    ///
    /// - Throws: Any errors while writing the renders to disk.
    /// - Returns: The URLs of the files written. The
    func writeToOutput() throws -> (svg: URL, png: URL) {
        let originalFileName: String = hashedFileName()
        let svgURL = try writeSVGToOutput(originalFileName: originalFileName, output: outputFolder())
        let pngURL = try writePNGToOutput(originalFileName: originalFileName, output: outputFolder())
        
        return (svgURL, pngURL)
    }

}
