//
//  Path.swift
//  
//
//  Created by Emory Dunn on 3/3/22.
//

import Foundation
import simd

public struct Path: Equatable {
    
    /// The points which make up the path
    var points: [Vector]
    
    var isEmpty: Bool { points.isEmpty }
    
    mutating func addPoint(_ point: Vector) {
        points.append(point)
    }
    
    /// Linearly interpret a point along the line to the specified distance.
    /// - Parameter distance: The distance from the start.
    func lerp(percent t: Double) -> Vector {
        var newPoints: [Vector] = []
        stride(from: 0, to: points.count, by: 1).forEach { i in
//            let p = points[i]
//            let p1 = points[i + 1]
//            let point = Vector.lerp(percent: t, start: p, end: p1)
//            newPoints.append(point)
        }
        
        return newPoints.last ?? points[0]
        
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

extension Path {

    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement {
        let element = XMLElement(name: "path")

        guard !isEmpty else { return element }

        let lines = points.map({
            "L \($0.x) \($0.y)"
            }).joined(separator: " ")

        let command = "M \(points[0].x),\(points[0].y) \(lines)"

        element.addAttribute(command, forKey: "d")

        element.addAttribute("black", forKey: "stroke")
        element.addAttribute(1, forKey: "stroke-width")
//        element.addAttribute(SwiftGraphicsContext.fillColor, forKey: "fill")

        return element
    }

}

extension XMLElement {

    /// Adds an attribute node to the receiver.
    /// - Parameters:
    ///   - value: The value to be converted into a string
    ///   - key: Name of the attribute
    public func addAttribute(_ value: CustomStringConvertible, forKey key: String) {
        let attr = XMLNode(kind: .attribute)
        attr.name = key
        attr.stringValue = String(describing: value)

        addAttribute(attr)
    }

}
