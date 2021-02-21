import Foundation
import AppKit

/// The base protocol for any shape that is drawable on screen
public protocol Shape {
    
    /// Draw the shape
    ///
    /// The default implementation of this method automatically draws into the current  context of `SwiftGraphicsContext`
    func draw()
    
    /// A Rectangle that contains the receiver
    var boundingBox: Rectangle { get }
}

extension Shape {

    /// Draw the shape
    ///
    /// The default implementation of this method automatically draws into the current  context of `SwiftGraphicsContext`
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

}

extension Array where Element: Shape {
    
    /// A convenience method to draw an array of Shapes
    public func draw() {
        self.forEach { $0.draw() }
    }
}
