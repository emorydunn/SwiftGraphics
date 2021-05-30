//
//  HatchFill.swift
//
//
//  Created by Emory Dunn on 5/1/21.
//

import Foundation

public class HatchFill {
    
    public var shape: SwiftGraphics.Polygon
    
    public var fillLines = Set<Line>()
    public var fullLines = [Line]()
    
    /// Fixed addition spacing to apply add to the noise value.
    ///
    /// A higher value will result in fewer paths
    ///
    /// `vect.y += noise + noiseSpacing`
    public var spacing: Double = 5
    
    public var angle: Radians = 0
    
    public init(_ shape: SwiftGraphics.Polygon) {
        self.shape = shape
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

        if Bool.random() {
            SwiftGraphicsContext.strokeWeight = Double(penWeight: 0.25)
        } else {
            SwiftGraphicsContext.strokeWeight = Double(penWeight: 0.5)
        }
        
        SwiftGraphicsContext.strokeColor = .black
        fillLines.forEach { path in
            path.draw()
        }

    }
    
}
