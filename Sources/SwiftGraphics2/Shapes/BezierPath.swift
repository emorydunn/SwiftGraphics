//
//  BezierPath.swift
//  
//
//  Created by Emory Dunn on 3/3/22.
//

import Foundation

/// Defines a Cubic Bézier curve. 
public struct BezierPath: Shape, Drawable {
    
    public var controlPoints: [Vector]
    
    public var style: Style
    
    public func pointOnPerimeter(_ t: Double) -> Vector {
        precondition(controlPoints.count > 0, "Path cannot be empty")
        
        if controlPoints.count == 1 {
            return controlPoints[0]
        }

        var bezPoints = controlPoints
        let n = controlPoints.count
        
        (1..<n).forEach { j in
            (0..<(n - j)).forEach { k in
                let p = bezPoints[k]
                let p1 = bezPoints[k + 1]
                
                bezPoints[k] = Vector.lerp(percent: t, start: p, end: p1)
            }
        }
        
        return bezPoints[0]
    }

    /// Determine the point at `t` by interpreting the Path as a Bézier curve.
    ///
    /// The method uses de Casteljau's algorithm. For values between `0` and `1`, inclusive, the point returned is
    /// between the first and last control points. Values outside that range will return a point elsewhere on the curve
    ///
    /// - Important: It is a programer error to call this method with an empty path.
    ///
    /// - Parameter t: The time value
    /// - Returns: The point along the curve.
    @available(*, deprecated, renamed: "pointOnPerimeter(_:)")
    public func bezier(_ t: Double) -> Vector {
        pointOnPerimeter(t)
    }
    
    /// Split the curve and return two new sub-curves.
    /// - Parameter percent: The point at which to split the curve.
    /// - Returns: A tuple containing the the two curves.
    public func splitCurve(at percent: Double) -> (BezierPath, BezierPath) {
        
        precondition(controlPoints.count > 0, "Path cannot be empty")
        
        let n = controlPoints.count
        
        // Start the pre-split curve with the initial point
        var preSplit: [Vector] = [controlPoints[0]]
        
        // Use the original curve to start the post-split curve
        var postSplit = controlPoints

        (1..<n).forEach { j in
            (0..<(n - j)).forEach { k in
                let p = postSplit[k]
                let p1 = postSplit[k + 1]
                
                // Calculate the new mid-point
                let l = Vector.lerp(percent: percent, start: p, end: p1)
                
                // Replace the point in the curve with the new point
                postSplit[k] = l
                
                // Add the first point of each level to the pre-curve
                if k == 0 {
                    preSplit.append(l)
                }

            }
        }
        
        return (BezierPath(preSplit), BezierPath(postSplit))
    }
    
}

extension BezierPath {
    public enum Style {
        case curve
        case sampled(Double)
    }
    
    /// Create a Path from the specified points.
    /// - Parameter points: Points which make up the Path.
    public init(_ points: [Vector], style: Style = .curve) {
        self.controlPoints = points
        self.style = style
    }
    
    /// Create a Path from the specified points.
    /// - Parameter points: Points which make up the Path.
    public init(_ points: Vector..., style: Style = .curve) {
        self.init(points, style: style)
    }
}

extension BezierPath: SVGDrawable {
    /// Create an `XMLElement` for the Path in its drawing style
    public func svgElement() -> XMLElement? {
        let element = XMLElement(name: "path")
        
        // For large paths, sample
        guard controlPoints.count <= 4 else {
            return sampled()
//                .strokeColor(strokeColor)
//                .strokeWidth(strokeWidth)
//                .fillColor(fillColor)
                .svgElement()
        }
        

        let lines = controlPoints
            .dropFirst()
            .map{ "\($0.x),\($0.y)" }
            .joined(separator: " ")
        
        // Three point curves need to be treated as quadratic curves,
        // otherwise use a cubic curve
        let curveType = controlPoints.count > 3 ? "C" : "Q"

        let command = "M \(controlPoints[0].x),\(controlPoints[0].y) \(curveType) \(lines)"

        element.addAttribute(command, forKey: "d")

        element.strokeColor(Color.black)
        element.strokeWidth(1)
        element.fillColor(nil)

        return element
    }
    
    public func debugSVG() -> XMLElement? {
        let path = Path(controlPoints).svgElement()!
        let curve = svgElement()!
        
        let element = XMLElement(name: "g")
        
        element.addChild(path)
        element.addChild(curve)
        
        return element
    }
}
