//
//  Math.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation


public struct Math {
    
    /// Square the specified number
    /// - Parameter n: Number to square
    public static func square(_ n: inout Double) {
        return n.square()
    }
    
    /// Return a new instance of a number which has been squared
    public static func squared(_ n: Double) -> Double {
        return n.squared()
    }
    
}



extension Double {
    
    /// Return a new Double that has been squared
    public func squared() -> Double {
        return pow(self, 2)
    }
    
    
    /// Square the receiver
    public mutating func square() {
        self = pow(self, 2)
    }
}
