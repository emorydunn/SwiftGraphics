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
    
    var title: String { get set }

    func setup()
    func draw()

}

extension Sketch {
    
    /// Returns the current `CGContext`
    public var context: CGContext? {
        NSGraphicsContext.current?.cgContext
    }
    
    /// Return a unique file name based on the time and a hash of the time
    ///
    /// The string takes the form of `YYYYMMDD-HHmmss-<short hash>`
    public func hashedFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMDD-HHmmss"
        
        let dateString = formatter.string(from: Date())
        
        let hash = dateString.sha1()
        let shortHash = String(hash.dropLast(hash.count - 8))
        
        let fileName = "\(dateString)-\(shortHash)"
        
        return fileName
    }
    
}

