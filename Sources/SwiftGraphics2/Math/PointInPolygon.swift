//
//  PointInPolygon.swift
//
//
//  Created by Emory Dunn on 6/5/21.
//
// Adapted to Swift from Practical Geometry Algorithms by
// Dan Sunday. The original copyright:
//
// Copyright 2001, 2012, 2021 Dan Sunday
// This code may be freely used and modified for any purpose
// providing that this copyright notice is included with it.
// There is no warranty for this code, and the author of it cannot
// be held liable for any real or imagined damage from its use.
// Users of this code must verify correctness for their application.

import Foundation

/// Tests if a point is Left|On|Right of an infinite line.
/// - Parameters:
///   - p0: First point in the line
///   - p1: Second point in the line
///   - p2: The point to test
/// - Returns:
///     - >0 for P2 left of the line through P0 and P1
///     - =0 for P2  on the line
///     - <0 for P2  right of the line
public func isLeft(p0: Vector, p1: Vector, p2: Vector) -> Double {
    return (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y)
}

/// Crossing number test for a point in a polygon.
///
/// - Important: The polygon must be closed, where the first and last points are the same.
/// - Parameters:
///   - point: The point to test
///   - polygon: The vertices of a polygon V[n+1] with V[n]==V[0]
/// - Returns: A boolean indicating whether the point is inside the polygon or not
public func crossingNumber(of point: Vector, polygon: [Vector]) -> Bool {
    // Ensure we have a polygon
    guard polygon.count > 2 else { return false }

    var count = 0
    polygon.paired { p0, p1 in
        if (p0.y <= point.y && p1.y > point.y) || // an upward crossing
            (p0.y > point.y && p1.y <= point.y) {  // a downward crossing
            let vt = (point.y - p1.y) / (p1.y - p0.y)
            
            if point.x < p0.x + vt * (p1.x - p0.x) { // P.x < intersect
                count += 1 // a valid crossing of y=P.y right of P.x
            }
        }
    }
    
    return count & 1 == 1
}

/// Winding number test for a point in a polygon.
///
/// - Important: The polygon must be closed, where the first and last points are the same.
/// - Parameters:
///   - point: The point to test
///   - polygon: The vertices of a polygon V[n+1] with V[n]==V[0]
/// - Returns: A boolean indicating whether the point is inside the polygon or not
public func windingNumber(of point: Vector, polygon: [Vector]) -> Bool {
    // Ensure we have a polygon
    guard polygon.count > 2 else { return false }
    
    // Close the shape if needed
    var workingPoints = polygon
    if polygon.first != polygon.last {
        workingPoints.append(workingPoints[0])
    }

    var count = 0
    workingPoints.paired { p0, p1 in
        if p0.y <= point.y { // start y <= P.y
            if p1.y > point.y { // an upward crossing
                if isLeft(p0: p0, p1: p1, p2: point) > 0 { // P left of  edge
                    count += 1 // have  a valid up intersect
                }
            }
        } else {
            if p1.y <= point.y { // a downward crossing
                if isLeft(p0: p0, p1: p1, p2: point) < 0 { // P right of  edge
                    count -= 1 // have  a valid down intersect
                }
            }
        }
    }
    
    return count != 0
}
