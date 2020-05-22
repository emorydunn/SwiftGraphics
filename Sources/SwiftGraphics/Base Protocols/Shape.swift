import Foundation
import AppKit

/// The base protocol for any shape that is drawable on screen
public protocol Shape {

    func draw()
    
//    var strokeColor: CGColor { get set }
//    var fillColor: CGColor { get set }
//    var strokeWeight: Double { get set }
//
}

extension Shape {

    public func draw() {
        // Important: Classes that directly conform to `DrawingContext`
        // must be listed first.
        // Conformance by extension will always succeed, because the
        // method doesn't need to know anything beyond the protocol
        
        switch SwiftGraphicsContext.current {
        case let c as SVGContext:
            (self as? SVGDrawable)?.draw(in: c)
        case let c as CGContext:
            (self as? CGDrawable)?.draw(in: c)
        default:
            break
        }
    }
    
//    /// Copy the style from another shape
//    /// - Parameter shape: The shape whose style will be copied
//    public mutating func copyStyle(from shape: Shape) {
//        self.fillColor = shape.fillColor
//        self.strokeColor = shape.strokeColor
//        self.strokeWeight = shape.strokeWeight
//    }
}


/// Any shape that can calculate points of intersection between itself and a `Line`
public protocol Intersectable: Shape {
    func lineIntersection(_ line: Line) -> [Vector]
    
    func lineSegments(_ line: Line, firstOnly: Bool) -> [Line]
    
}

extension Intersectable {
    
    public func lineIntersection(startPoint: Vector, endPoint: Vector) -> [Vector] {
        return lineIntersection(Line(startPoint, endPoint))
    }
    
    /// Returns  `Line` segments made of paired points where the specified line intersects
    ///
    /// - Parameter line: The line to test for intersection
    /// - Parameter firstOnly: Return only a `Line` to the closest intersection point
    public func lineSegments(_ line: Line, firstOnly: Bool) -> [Line] {
        var intersections = self.lineIntersection(line)

        guard intersections.count > 0 else {
            return []
        }
        intersections.insert(line.start, at: 0)
        intersections.append(line.end)

        var segments = intersections
            .sortedByDistance(from: line.start)
            .paired()
            .map { Line($0.0, $0.1) }

        if firstOnly {
            segments.removeLast(segments.count - 1)
        }


        return segments
    }
    
    public func lineSegments(startPoint: Vector, endPoint: Vector, firstOnly: Bool) -> [Line] {
        return lineSegments(Line(startPoint, endPoint), firstOnly: firstOnly)
    }
    
}
