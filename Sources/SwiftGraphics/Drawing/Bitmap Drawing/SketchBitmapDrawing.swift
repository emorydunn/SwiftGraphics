//
//  SketchBitmapDrawing.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 4/15/21.
//  Copyright © 2021 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation
import AppKit

public extension Sketch {
    /// Draws the sketch to an image
    func drawToImage() -> NSImage? {
        let image = NSImage(size: size.cgSize)
        image.lockFocusFlipped(true)
        
        // Set the context to CoreGraphics
        SwiftGraphicsContext.current = NSGraphicsContext.current?.cgContext
        
        draw()
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
        guard let image = drawToImage() else { return }
        try saveImage(image, to: url)
    }
    
}
