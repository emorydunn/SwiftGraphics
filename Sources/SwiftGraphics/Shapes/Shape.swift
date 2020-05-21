import Foundation
import AppKit

/// The base protocol for any shape that is drawable on screen
public protocol Shape: Codable {
    func draw()
}

extension Shape {
    /// Returns the `CGContext` of the current `NSGraphicsContext`
    var context: CGContext? { NSGraphicsContext.current?.cgContext }
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
