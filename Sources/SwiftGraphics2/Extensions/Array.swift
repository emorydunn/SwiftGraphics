//
//  Array.swift
//  
//
//  Created by Emory Dunn on 10/13/21.
//

import Foundation

extension Array {

    /// Calls the given closure on each pair of elements in the sequence.
    ///
    /// ```
    /// let a = ["zero", "one", "two", "three", "four"]
    /// array.paired { _, _ in } // [("zero", "one"), ("one", "two"), ("two", "three"), ("three", "four")]
    /// ```
    public func paired(_ pair: (Element, Element) -> Void) {

        self.enumerated().forEach { offset, item in
            guard offset < (self.count - 1) else { return }

            let nextItem = self[offset + 1]
            
            pair(item, nextItem)

        }
    }
    
    /// Returns the arrays elements in paired tuples
    ///
    /// ```
    /// let a = ["zero", "one", "two", "three", "four"]
    /// let p = array.paired() // [("zero", "one"), ("one", "two"), ("two", "three"), ("three", "four")]
    /// ```
    public func paired() -> [(Element, Element)] {
        var pairedItems = [(Element, Element)]()

        self.enumerated().forEach { offset, item in
            guard offset < (self.count - 1) else { return }

            let nextItem = self[offset + 1]

            pairedItems.append((item, nextItem))

        }

        return pairedItems
    }
    
}

extension Array where Element == Vector {
    
    /// Determine the bounding box for the points contained in the array.
    var boundingBox: Rectangle {
        var maxX = Double.zero
        var maxY = Double.zero
        var minX = Double.infinity
        var minY = Double.infinity
        
        forEach {
            maxX = Swift.max($0.x, maxX)
            maxY = Swift.max($0.y, maxY)
            minX = Swift.min($0.x, minX)
            minY = Swift.min($0.y, minY)
        }
        
        let width = maxX - minX
        let height = maxY - minY
        
        return Rectangle(centerX: minX + width / 2,
                         y: minY + height / 2,
                         width: width,
                         height: height)

    }
}
