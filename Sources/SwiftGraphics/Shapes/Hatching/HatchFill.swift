//
//  HatchFill.swift
//
//
//  Created by Emory Dunn on 5/1/21.
//

import Foundation

/// Draws a shape with hatched lines
public class HatchFill {
    
    /// The shape to fill
    public var shape: SwiftGraphics.Polygon
    
    /// The lines making up the hatching
    public var fillLines = Set<Line>()
    
    /// The full lines
    public var fullLines = [Line]()
    
    
    /// The spacing between lines
    public var spacing: Double = 5
    
    /// The angle of the hatched lines
    public var angle: Radians = 0
    
    public init(_ shape: SwiftGraphics.Polygon, angle: Radians, spacing: Double) {
        self.shape = shape
        self.angle = angle
        self.spacing = spacing
    }
    
    public func iteratePaths() {

        // Make a box which completrly covers the shape at the desired rotation
        
        let hypot = sqrt(shape.boundingBox.width.squared() + shape.boundingBox.height.squared())
        
        let box = Rectangle(center: shape.center,
                            width: hypot,
                            height: hypot)

        let newLines: [Line] = stride(from: box.minY, through: box.maxY, by: spacing).compactMap { yPos in
            let startingPoint = Vector(box.minX, yPos)
            startingPoint.rotate(by: angle, around: box.center)
            let endingPoint = Vector(box.maxX, yPos)
            endingPoint.rotate(by: angle, around: box.center)
    
            // Create a line covering the entire shape
            let fullLine = Line(startingPoint, endingPoint)
            
            fullLines.append(fullLine)
            
            // Clip the line to the shpe
            let inters = fullLine.intersections(with: shape)
            
            // Ensure we have two intersection points
            guard inters.count == 2 else { return nil }
            
            return Line(inters[1], inters[0])
        }

        fillLines = Set(newLines)
        
    }
    
    public func draw() {

        fillLines.forEach { path in
            path.draw()
        }

    }
    
}
