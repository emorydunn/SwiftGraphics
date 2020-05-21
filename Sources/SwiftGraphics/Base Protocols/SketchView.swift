//
//  SketchView.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import AppKit

/// A basic subclass of NSView for displaying a `Sketch`
class SketchView: NSView {
    
    /// The `Sketch` to display
    var sketch: Sketch?
    
    /// Whether this is the first run of the sketch, controls whether `.setup()` is called on `.draw(_:)`
    var firstRun = true
    
    /// Calls the sketches `.draw()` method
    override func draw(_ dirtyRect: NSRect) {
        
        if firstRun {
            sketch?.setup()
            firstRun = false
        }
        sketch?.draw()
        
    }
    
    /// Draws the sketch to an image
    func drawToImage() -> NSImage {
        let image = NSImage(size: self.frame.size)
        image.lockFocusFlipped(false)
        if firstRun {
            sketch?.setup()
        }
        sketch?.draw()
        image.unlockFocus()
        
        return image
    }
    
    
    /// Save an image to the specified URL
    /// - Parameters:
    ///   - image: Image to save
    ///   - url: URL to save to
    func saveImage(_ image: NSImage, to url: URL) throws {
        
        guard let tiffData = image.tiffRepresentation else {
            return
        }
        let imageRep = NSBitmapImageRep(data: tiffData)
        let data = imageRep?.representation(using: .png, properties: [:])
        
        try data?.write(to: url)
    }
    
    /// Draw the sketch to an image and attempt to save it
    /// - Parameter url: URL to write the image to
    func saveImage(to url: URL) throws {
        let image = drawToImage()
        try saveImage(image, to: url)
    }
    
    /// Passes clicks to the sketch
    @IBAction func clickGestureAction(_ sender: NSClickGestureRecognizer) {
        let point = sender.location(in: self)
        let v = Vector(point.x, point.y)
        (sketch as? InteractiveSketch)?.mouseDown(at: v)
        
        self.needsDisplay = true
        
    }
    
    /// Passes pan gestures to the sketch
    @IBAction func panGestureAction(_ sender: NSPanGestureRecognizer) {
        let point = sender.location(in: self)
        let v = Vector(point.x, point.y)
        (sketch as? InteractiveSketch)?.mousePan(at: v)
        
        self.needsDisplay = true
    }
    
    /// Passes scroll events to the sketch
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)

        let windowPoint = event.locationInWindow
        let localPoint = self.convert(windowPoint, to: nil)
        let v = Vector(localPoint.x, localPoint.y)
        
        (sketch as? InteractiveSketch)?.scrolled(
            deltaX: Double(event.scrollingDeltaX),
            deltaY: Double(event.scrollingDeltaY),
            at: v
        )
        
        self.needsDisplay = true
    }
    
}
