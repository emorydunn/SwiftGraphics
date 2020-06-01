//
//  Array.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

extension Array {
    /// Returns the arrays elements in paired tuples
    ///
    /// ```
    /// let a = ["zero", "one", "two", "three", "four"]
    /// let p = array.paired() // [("zero", "one"), ("one", "two"), ("two", "three"), ("three", "four")]
    /// ```
    func paired() -> [(Element, Element)] {
        var pairedItems = [(Element, Element)]()
        
        self.enumerated().forEach { offset, item in
            guard offset < (self.count - 1) else { return }
            
            let nextItem = self[offset + 1]
            
            pairedItems.append((item, nextItem))
            
        }
        
        return pairedItems
    }
    
    /// Ensure the given index is not out of bouds
    /// - Parameter index: index
    func safeElement(_ index: Int) -> Element? {
        guard index >= 0 else { return nil }
        guard index <= self.endIndex - 1 else { return nil }
        
        return self[index]
    }
}

extension Array where Element == Vector {
    
    /// Sort an array of `Vector`s by distance to the specified point
    /// - Parameter point: Origin point
    mutating func sortByDistance(from point: Vector) {
        self.sort { (lhs, rhs) -> Bool in
            point.dist(lhs) < point.dist(rhs)
        }
    }
    
    /// Return a new array of `Vector`s sorted by distance to the specified point
    /// - Parameter point: Origin point
    func sortedByDistance(from point: Vector) -> [Vector] {
        return self.sorted { (lhs, rhs) -> Bool in
            point.dist(lhs) < point.dist(rhs)
        }
    }
}
