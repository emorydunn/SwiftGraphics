//
//  Rectangle.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import simd

public struct Rectangle: Polygon {
    
    public var origin: Vector {
        didSet {
            self.points = makePolygon()
        }
    }
    
    public var height: Double {
        didSet {
            self.points = makePolygon()
        }
    }
    
    public var width: Double {
        didSet {
            self.points = makePolygon()
        }
    }
    
    public var rotation: Angle {
        didSet {
            self.points = makePolygon()
        }
    }
    
    public private(set) var points: [Vector] = []

    public init(origin: Vector, height: Double, width: Double, rotation: Angle = .degrees(0)) {
        self.origin = origin
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
        
        return [
            Vector(-width / 2,  height / 2, transformation: compoundMatrix),
            Vector( width / 2,  height / 2, transformation: compoundMatrix),
            Vector( width / 2, -height / 2, transformation: compoundMatrix),
            Vector(-width / 2, -height / 2, transformation: compoundMatrix),
        ]
    }
}
