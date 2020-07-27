//
//  Size.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/12/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// A structure that contains width and height values.
public struct Size: Equatable {
    
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
}
