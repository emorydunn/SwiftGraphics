import Foundation
import AppKit

/// The base protocol for any shape that is drawable on screen
public protocol Shape {

    func draw()

    var boundingBox: Rectangle { get }
}

extension Shape {

    public func draw() {
        // Important: Classes that directly conform to `DrawingContext`
        // must be listed first.
        // Conformance by extension will always succeed, because the
        // method doesn't need to know anything beyond the protocol

        switch SwiftGraphicsContext.current {
        case let context as SVGContext:
            (self as? SVGDrawable)?.draw(in: context)
        case let context as CGContext:
            (self as? CGDrawable)?.draw(in: context)
        default:
            break
        }
    }

//    /// Copy the style from another shape
//    /// - Parameter shape: The shape whose style will be copied
//    public mutating func copyStyle(from shape: Shape) {
//        self.fillColor = shape.fillColor
//        self.strokeColor = shape.strokeColor
//        self.strokeWeight = shape.strokeWeight
//    }
}
