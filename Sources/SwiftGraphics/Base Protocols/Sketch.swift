//
//  Sketch.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import AppKit


public protocol Sketch {
    
    static var title: String { get set }
    
    var size: Size { get set }
    
    init()

    func setup()
    func draw()

}

extension Sketch {
    
    /// Returns the current `DrawingContext`
    public var context: DrawingContext? {
        SwiftGraphicsContext.current
    }
    
    /// Return a unique file name based on the time and a hash of the time
    ///
    /// The string takes the form of `YYYYMMDD-HHmmss-<short hash>`
    public func hashedFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        
        let dateString = formatter.string(from: Date())
        
        let hash = dateString.sha1()
        let shortHash = String(hash.dropLast(hash.count - 8))
        
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

