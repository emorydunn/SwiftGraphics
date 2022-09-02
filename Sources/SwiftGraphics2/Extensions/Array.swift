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
    
    /// Calls the given closure on each pair of elements in the sequence.
    ///
    /// ```
    /// let a = ["zero", "one", "two", "three", "four"]
    /// array.paired { _, _ in } // [("zero", "one"), ("one", "two"), ("two", "three"), ("three", "four")]
    /// ```
    public func pairedMap<T>(_ pair: (Element, Element) -> T) -> [T] {

        self.enumerated().compactMap { offset, item in
            guard offset < (self.count - 1) else { return nil }

            let nextItem = self[offset + 1]
            
            return pair(item, nextItem)

        }
    }
    
    /// Calls the given closure on each pair of elements in the sequence.
    ///
    /// ```
    /// let a = ["zero", "one", "two", "three", "four"]
    /// array.paired { _, _ in } // [("zero", "one"), ("one", "two"), ("two", "three"), ("three", "four")]
    /// ```
    public func pairedCompactMap<T>(_ pair: (Element, Element) -> T?) -> [T] {

        self.enumerated().compactMap { offset, item in
            guard offset < (self.count - 1) else { return nil }

            let nextItem = self[offset + 1]
            
            return pair(item, nextItem)

        }
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
    
    /// The combined length of each line segment
    public var length: Double {
        paired().reduce(into: 0) { partialResult, vectors in
            partialResult += vectors.1.distance(to: vectors.0)
        }
    }
    
    /// Linearly interpret a point along the line to the specified distance.
    ///
    /// - Important: It is a programer error to call this method with an empty path.
    /// - Parameter distance: The distance from the start.
    public func lerp(percent t: Double) -> Vector {
        
        precondition(count > 0, "Path cannot be empty")
        
        // The distance along the path
        let distance = length * t
        
        // The current distance we've lerped
        var distanceTravelled: Double = 0
        
        // The point
        var point: Vector = last!
        
        // Iterate through pairs of line segments
        for points in paired() {
            let (lhs, rhs) = points
            
            // Calculate the distance between the points
            let dist = rhs.distance(to: lhs)

            // If the new length is and the travelled length is less than the total distance
            // "jump" to the end of the segment by adding it's length
            
            // If the combined distance is greater than our needed distance
            // subtract the travelled and create a new percent on the line
            if dist + distanceTravelled < distance {
                distanceTravelled += dist
            } else {
                let lineP = (distance - distanceTravelled) / dist
                point = Vector.lerp(percent: lineP, start: lhs, end: rhs)
                break
            }
        
        }
        
        return point

    }
}
