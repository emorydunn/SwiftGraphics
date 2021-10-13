//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/10/21.
//

import Foundation
import simd


/// A figure defined by three or more points.
public protocol Polygon {
    
    var points: [Vector] { get }
    
}

public extension Polygon {
    
    /// Determine the bounding box for the polygon.
    var boundingBox: Rectangle {
        points.boundingBox
    }
    
    /// Determine whether a point is contained by the polygon.
    ///
    /// This method uses the winding number algorithm by Dan Sunday.
    /// - Parameter point: The point to test
    /// - Returns: A boolean indicating whether the polygon contains the point.
    func contains(point: Vector) -> Bool {
        windingNumber(of: point, polygon: points)
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
