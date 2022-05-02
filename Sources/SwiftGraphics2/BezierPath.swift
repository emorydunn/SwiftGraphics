//
//  BezierPath.swift
//  
//
//  Created by Emory Dunn on 3/3/22.
//

import Foundation

/// Defines a Cubic Bézier curve. 
public struct BezierPath {
    
    public var controlPoints: [Vector]
    
    public var style: Style
    
    /// Determine the point at `t` by interpreting the Path as a Bézier curve.
    ///
    /// The method uses de Casteljau's algorithm. For values between `0` and `1`, inclusive, the point returned is
    /// between the first and last control points. Values outside that range will return a point elsewhere on the curve
    ///
    /// - Important: It is a programer error to call this method with an empty path.
    ///
    /// - Parameter t: The time value
    /// - Returns: The point along the curve.
    public func bezier(_ t: Double) -> Vector {
        
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
    
    public func splitCurve(at percent: Double) {
        // The point along the path
//        let point = bezier(percent)
        
        
    }
    
}

extension BezierPath {
    public enum Style {
        case curve
        case sampled(Double)
    }
    
    /// Create a Path from the specified points.
    /// - Parameter points: Points which make up the Path.
    init(_ points: [Vector], style: Style = .curve) {
        self.controlPoints = points
        self.style = style
    }
    
    /// Create a Path from the specified points.
    /// - Parameter points: Points which make up the Path.
    init(_ points: Vector..., style: Style = .curve) {
        self.init(points, style: style)
    }
}
