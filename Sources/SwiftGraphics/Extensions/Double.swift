//
//  Double.swift
//  
//
//  Created by Emory Dunn on 7/27/20.
//

import Foundation

extension Double {
    
    /// Return a new Double that has been squared
    public func squared() -> Double {
        return pow(self, 2)
    }
    
    /// Square the receiver
    public mutating func square() {
        self = pow(self, 2)
    }
    
    /// Negate the receiver if it is less that the specified number.
    mutating func negate(ifLessThan num: Double) {
        if self < num {
            self.negate()
        }
    }
    
    /// Creates a new value in points from the specified number of mm.
    /// - Parameter mm: Size in millimeters. 
    init(penWeight mm: Double) {
        self = mm * 2.8
    }
}

