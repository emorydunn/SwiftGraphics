//
//  Path.swift
//  
//
//  Created by Emory Dunn on 3/3/22.
//

import Foundation
import simd

/// A straight-line path made up of vector points.
public struct Path: Equatable, Shape, Drawable {

    /// The points which make up the path
    public var points: [Vector]
    
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
    
    public func pointOnPerimeter(_ t: Double) -> Vector {
        points.lerp(percent: t)
    }

	public func lerp(_ t: Double) -> Vector {
		points.lerp(percent: t)
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
    public func svgElement() -> XMLElement? {
        let element = XMLElement(name: "polyline")

        element.addAttribute(points.map { "\($0.x),\($0.y)" }.joined(separator: " "),
                             forKey: "points")

        element.strokeColor(Color.black)
        element.strokeWidth(1)
        element.fillColor(nil)

        return element
    }
}
