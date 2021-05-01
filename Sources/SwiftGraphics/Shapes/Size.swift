//
//  Size.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/12/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A structure that contains width and height values.
public struct Size: Hashable {
    
    /// The width value
    public let width: Double
    
    /// The height value
    public let height: Double
    
    /// Creates a size with dimensions specified as floating-point values.
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    /// Returns a CGSize object
    public var cgSize: CGSize {
        CGSize(width: width, height: height)
    }
    
    /// Returns a NSSize object
    public var nsSize: NSSize {
        NSSize(width: width, height: height)
    }
    
    /// The center of a rectangle with the origin `(0, 0)`
    public var center: Vector {
        Vector(
            width / 2,
            height / 2
        )
    }
    
    /// Rotate the `Size` to a landscape orientation.
    /// - Returns: A rotated Size
    public func landscape() -> Size {
        if height > width {
            var newHeight = height
            var newWidth = width
            swap(&newHeight, &newWidth)
            
            return Size(width: newWidth, height: newHeight)
        } else {
            return self
        }
    }
    
    /// Rotate the `Size` to a portrait orientation.
    /// - Returns: A rotated Size
    public func portrait() -> Size {
        if height < width {
            var newHeight = height
            var newWidth = width
            swap(&newHeight, &newWidth)
            
            return Size(width: newWidth, height: newHeight)
        } else {
            return self
        }
    }
    
    /// Length of the long side
    public var longSide: Double { max(width, height) }
    
    /// Length of the short side
    public var shortSide: Double { min(width, height) }
}
