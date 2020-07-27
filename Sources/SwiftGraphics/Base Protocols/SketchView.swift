//
//  SketchView.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import AppKit

/// A basic subclass of NSView for displaying a `Sketch`
open class SketchView: NSView {

    /// Use top-left origin
    override open var isFlipped: Bool { true }

    public private(set) var fileName: String?

    /// The `Sketch` to display
    open var sketch: Sketch? {
        didSet {
            canDrawConcurrently = true
            needsDisplay = true
            displayIfNeeded()
        }
    }

    /// Calls the sketches `.draw()` method
    override open func draw(_ dirtyRect: NSRect) {
        guard let sketch = sketch else { return }

        // Set the context to CoreGraphics
        SwiftGraphicsContext.current = NSGraphicsContext.current?.cgContext

        sketch.draw()
        fileName = sketch.hashedFileName()
        
    }

    /// Draws the sketch to an image
    open func drawToImage() -> NSImage {
        let image = NSImage(size: self.frame.size)
        image.lockFocusFlipped(true)

        // Set the context to CoreGraphics
        SwiftGraphicsContext.current = NSGraphicsContext.current?.cgContext

        sketch?.draw()
        image.unlockFocus()

        return image
    }

    open func drawToSVG() -> XMLDocument {

        let context = SVGContext(sketch: self)

        SwiftGraphicsContext.current = context

        sketch?.draw()

        (sketch as? SketchViewDelegate)?.willWriteToSVG(with: context)
        let doc = context.makeDoc()

        return doc
    }

    /// Save an image to the specified URL
    /// - Parameters:
    ///   - image: Image to save
    ///   - url: URL to save to
    open func saveImage(_ image: NSImage, to url: URL) throws {

        guard let tiffData = image.tiffRepresentation else {
            return
        }
        let imageRep = NSBitmapImageRep(data: tiffData)
        let data = imageRep?.representation(using: .png, properties: [:])

        try data?.write(to: url)
    }

    /// Draw the sketch to an image and attempt to save it
    /// - Parameter url: URL to write the image to
    open func saveImage(to url: URL) throws {
        let image = drawToImage()
        try saveImage(image, to: url)
    }
    
    open func saveSVG(to url: URL) throws {
        let context = SVGContext(sketch: self)
        
        SwiftGraphicsContext.current = context
        
        sketch?.draw()
        
        (sketch as? SketchViewDelegate)?.willWriteToSVG(with: context)
        
        try context.writeSVG(to: url)

    }

    /// Passes clicks to the sketch
    @IBAction open func clickGestureAction(_ sender: NSClickGestureRecognizer) {
        let point = sender.location(in: self)
        let vector = Vector(point.x, point.y)
        (sketch as? InteractiveSketch)?.mouseDown(at: vector)

        self.needsDisplay = true

    }

    /// Passes pan gestures to the sketch
    @IBAction open func panGestureAction(_ sender: NSPanGestureRecognizer) {
        let point = sender.location(in: self)
        let vector = Vector(point.x, point.y)
        (sketch as? InteractiveSketch)?.mousePan(at: vector)

        self.needsDisplay = true
    }

    /// Passes scroll events to the sketch
    override open func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)

        let windowPoint = event.locationInWindow
        let localPoint = self.convert(windowPoint, to: nil)
        let vector = Vector(localPoint.x, localPoint.y)

        (sketch as? InteractiveSketch)?.scrolled(
            deltaX: Double(event.scrollingDeltaX),
            deltaY: Double(event.scrollingDeltaY),
            at: vector
        )

        self.needsDisplay = true
    }

}
