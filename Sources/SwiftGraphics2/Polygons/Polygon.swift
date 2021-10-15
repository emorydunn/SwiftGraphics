//
//  Polygon.swift
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
