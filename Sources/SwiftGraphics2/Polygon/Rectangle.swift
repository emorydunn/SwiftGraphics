//
//  Rectangle.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import simd

/// A rectangle defined by its center, width, and height.
public struct Rectangle: Polygon {
    
    /// The center of the rectangle
    public var origin: Vector {
        didSet {
            self.points = makePolygon()
        }
    }
    
    /// The width of the rectangle
    public var width: Double {
        didSet {
            self.points = makePolygon()
        }
    }
    
    /// The height of the rectangle
    public var height: Double {
        didSet {
            self.points = makePolygon()
        }
    }
    
    /// The angle of rotation of the rectangle
    public var rotation: Angle {
        didSet {
            self.points = makePolygon()
        }
    }
    
    /// The points that make up the rectangle
    public private(set) var points: [Vector] = []

    public init(center: Vector, width: Double, height: Double, rotation: Angle = .degrees(0)) {
        self.origin = center
        self.height = height
        self.width = width
        self.rotation = rotation
        
        self.points = makePolygon()
    }
    
    public init(centerX x: Double, y: Double, width: Double, height: Double, rotation: Angle = .degrees(0)) {
        self.origin = Vector(x, y)
        self.height = height
        self.width = width
        self.rotation = rotation
        
        self.points = makePolygon()
    }
    
    /// Calculates the points of the rectangle by applying a matrix transformation.
    ///
    /// The points start in the top left and proceed clockwise:
    /// ```
    /// +--------+
    /// |0      1|
    /// |        |
    /// |3      2|
    /// +--------+
    /// ```
    public func makePolygon() -> [Vector] {
        let transMatrix = MatrixTransformation.translate(vector: origin)
        let rotMatrix = MatrixTransformation.rotate(by: rotation)
        let compoundMatrix = transMatrix * rotMatrix
        
        // Center rectangle
        return [
            Vector(-width / 2,  height / 2, transformation: compoundMatrix),
            Vector( width / 2,  height / 2, transformation: compoundMatrix),
            Vector( width / 2, -height / 2, transformation: compoundMatrix),
            Vector(-width / 2, -height / 2, transformation: compoundMatrix),
        ]
        
        // Corner rectangle
//        return [
//            Vector(0,  0, transformation: compoundMatrix),
//            Vector(width,  0, transformation: compoundMatrix),
//            Vector(width, height, transformation: compoundMatrix),
//            Vector(0, height, transformation: compoundMatrix),
//        ]
    }
}
