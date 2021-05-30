//
//  OverflowHatch.swift
//
//
//  Created by Emory Dunn on 5/2/21.
//

import Foundation
import SwiftGraphics

/// A fill that may overflow the bounds of the original shape
public class OverflowHatch: Hatch {
    
    public override func iteratePaths() {

        // Make the box a little wider to ensure we have intersections at full width
        let box = Rectangle(center: shape.center,
                            width: shape.boundingBox.width + 10,
                            height: shape.boundingBox.height)

        let newLines: [Line] = stride(from: box.minY, through: box.maxY, by: spacing).compactMap { yPos in
            let startingPoint = Vector(box.minX, yPos)
            let endingPoint = Vector(box.maxX, yPos)
    
            // Create a line covering the entire shape
            let fullLine = Line(startingPoint, endingPoint)
            
            fullLines.append(fullLine)
            
            // Clip the line to the shpe
            let inters = fullLine.intersections(with: shape)
            
            inters.forEach {
                $0.rotate(by: angle, around: box.center)
            }

            // Ensure we have two intersection points
            guard inters.count == 2 else { return nil }
            
            return Line(inters[1], inters[0])
        }
        
        print("Added \(newLines.count) lines")
        fillLines = Set(newLines)
        
    }
  
}
