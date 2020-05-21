//
//  CircleEmitter.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 5/20/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// An circular emitter that emits rays along its perimiter
public class CircleEmitter: Circle, Emitter {
    
    /// Angle of the step between emitted rays
    ///
    /// The value is clamped to a minimum of `0`
    public var rayStep: Degrees
    {
        didSet {
            if rayStep < 0 {
                rayStep = 0
            }
        }
    }
    
    /// Visual style for the emitter's rays
    public var style: RayTraceStyle = .line
    
    enum CodingKeys: String, CodingKey {
        case rayStep, style
    }
    
    /// Instantiate a new emitter at the specified coordinates
    /// - Parameters:
    ///   - x: Center X coordinate
    ///   - y: Center Y coordinate
    ///   - radius: Radius of the emitter
    ///   - rayStep: Angle between emitted rays
    public init(x: Double, y: Double, radius: Double, rayStep: Double) {
        self.rayStep = rayStep
        super.init(x: x, y: y, radius: radius)
        
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Caster Values
        self.rayStep = try container.decode(Double.self, forKey: .rayStep)
        self.style = try container.decode(RayTraceStyle.self, forKey: .style)
        
        try super.init(from: decoder)
        
    }
    
    /// Draw the emitter and ray trace using the specified `BoundingBox` and objects
    /// - Parameters:
    ///   - boundingBox: `BoundingBox` for ray termination
    ///   - objects: Objects to test for intersection when casting rays
    public func draw(boundingBox: BoundingBox, objects: [Intersectable]) {
        
        // Draw the circle
        if case .line = style {
            super.draw()
        }
        
        // Make a mutable copy
        var objects = objects
        
        // Remove this raycaster from the list
        objects.removeAll { ($0 as? CircleEmitter) === self }
        
        // Nothing to do if there are no rays
        guard rayStep > 0 else { return }

        // Stride through the circle, stepping by degree
        stride(from: rayStep, through: 360, by: rayStep).forEach { angle in
            let rAngle = Double(angle).toRadians()
            
            let origin = pointOnCircle(rAngle)
            let intersections = self.intersections(for: rAngle, origin: origin, bb: boundingBox, objects: objects)
            
            drawIntersections(intersections)
            
        }
        
    }
    
    
}
