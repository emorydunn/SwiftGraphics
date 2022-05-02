//
//  Path.swift
//  
//
//  Created by Emory Dunn on 3/3/22.
//

import Foundation
import simd

/// A straight-line path made up of vector points.
public struct Path: Equatable, Drawable {

    /// The points which make up the path
    public var points: [Vector]
    
    /// Color of the outline of the shape
    public var strokeColor: Color?
    
    /// Color of the fill of the shape
    public var fillColor: Color?
    
    /// Weight of the outline of the shape
    public var strokeWidth: Double?
    
    public var isEmpty: Bool { points.isEmpty }
    
    mutating func addPoint(_ point: Vector) {
        points.append(point)
    }
    
    /// The combined length of each line segment
    public var length: Double {
        points.paired().reduce(into: 0) { partialResult, vectors in
            partialResult += vectors.1.distance(to: vectors.0)
        }
    }
    
    /// Linearly interpret a point along the line to the specified distance.
    ///
    /// - Important: It is a programer error to call this method with an empty path.
    /// - Parameter distance: The distance from the start.
    public func lerp(percent t: Double) -> Vector {
        
        precondition(points.count > 0, "Path cannot be empty")
        
        // The distance along the path
        let distance = length * t
        
        // The current distance we've lerped
        var distanceTravelled: Double = 0
        
        // The point
        var point: Vector = points.last!
        
        // Iterate through pairs of line segments
        for points in points.paired() {
            let (lhs, rhs) = points
            
            // Calculate the distance between the points
            let dist = rhs.distance(to: lhs)
            
            print(distanceTravelled, distance, dist)
            
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

public extension Path {
    
    /// Create a Path from the specified points.
    /// - Parameter points: Points which make up the Path.
    init(_ points: [Vector]) {
        self.points = points
    }
    
    /// Create a Path from the specified points.
    /// - Parameter points: Points which make up the Path.
    init(_ points: Vector...) {
        self.init(points)
    }
    
    /// Create a Path by striding to a value, retuning a point at each step.
    /// - Parameters:
    ///   - start: The starting value to use for the sequence. If the sequence contains any values, the first one is start.
    ///   - end: An end value to limit the sequence. end is never an element of the resulting sequence.
    ///   - stride: The amount to step by with each iteration. A positive stride iterates upward; a negative stride iterates downward.
    ///   - generator: The method called to return a `Vector` at the given value.
    init(strideFrom start: Double, to end: Double, by stride: Double, _ generator: (Double) -> Vector) {
        let points = Swift.stride(from: start, to: end, by: stride).map(generator)
        
        self.init(points)
    }
    
    /// Create a Path by striding to a value, retuning a point at each step.
    /// - Parameters:
    ///   - start: The starting value to use for the sequence. If the sequence contains any values, the first one is start.
    ///   - end: An end value to limit the sequence. end is an element of the resulting sequence if and only if it can be produced from start using steps of stride.
    ///   - stride: The amount to step by with each iteration. A positive stride iterates upward; a negative stride iterates downward.
    ///   - generator: The method called to return a `Vector` at the given value.
    init(strideFrom start: Double, through end: Double, by stride: Double, _ generator: (Double) -> Vector) {
        let points = Swift.stride(from: start, through: end, by: stride).map(generator)
        
        self.init(points)
    }
    
    /// Determine the bounding box for the polygon.
    var boundingBox: Rectangle {
        points.boundingBox
    }
    
}

extension Path: SVGDrawable {
    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "polyline")

        element.addAttribute(points.map { "\($0.x),\($0.y)" }.joined(separator: " "),
                             forKey: "points")

        element.strokeColor(strokeColor)
        element.strokeWidth(strokeWidth)
        element.fillColor(fillColor)

        return element
    }
}
