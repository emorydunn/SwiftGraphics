//
//  BoundingBox.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation
import CoreGraphics

/// A specialized `Rectangle` which is inset from the canvas size
public class BoundingBox: Rectangle {

    /// Amount to inset the bounding box from the canvas
    public var inset: Double

    enum CodingKeys: String, CodingKey {
        case inset
    }

    /// Instantiate a new `BoundingBox`
    /// - Parameter inset: Margin from the edge
    public init(inset: Double = 100) {
        self.inset = inset
        super.init(x: 0, y: 0, width: 0, height: 0)
    }

    /// Draw the `BoundingBox`
    ///
    /// This method calls `.update()` before drawing
    public func draw() {
        self.update()
        super.draw()
    }

    /// Update the size of the rectangle based on the current context
    public func update() {

        let contextWidth: Double
        let contextHeight: Double

        switch SwiftGraphicsContext.current {
        case let context as SVGContext:
            contextWidth = Double(context.width)
            contextHeight = Double(context.height)
        case let context as CGContext:
            contextWidth = Double(context.width) / 2
            contextHeight = Double(context.height) / 2
        default:
            return
        }

        self.x = inset
        self.y = inset
        self.width = contextWidth - (inset * 2)
        self.height = contextHeight - (inset * 2)
    }
    
    /// Terminate a ray. 
    public override func modifyRay(_ ray: Ray) {
        ray.terminateRay()
    }
}
