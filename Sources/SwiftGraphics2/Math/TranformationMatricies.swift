//
//  TranformationMatricies.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import simd

public enum MatrixTransformation {
    
    /// Create a transformation matrix to rotate a vector.
    /// - Parameter angle: The angle of rotation.
    /// - Returns: A rotation matrix.
    public static func rotate(by angle: Angle) -> simd_double3x3 {
        let rows = [
            simd_double3( cos(angle.radians), sin(angle.radians), 0),
            simd_double3(-sin(angle.radians), cos(angle.radians), 0),
            simd_double3( 0,          0,          1)
        ]
        
        return double3x3(rows: rows)
    }
    
    /// Create a transformation matrix to translate a vector.
    /// - Parameter x: The amount to move in the x axis.
    /// - Parameter y: The amount to move in the y axis.
    /// - Returns: A translation matrix.
    public static func translate(x: Double, y: Double) -> simd_double3x3 {
        var matrix = matrix_identity_double3x3
            
        matrix[2, 0] = x
        matrix[2, 1] = y
        
        return matrix
    }
    
    /// Create a transformation matrix to translate a vector.
    /// - Parameter vector: A Vector describing the translation.
    /// - Returns: A translation matrix.
    public static func translate(vector: Vector) -> simd_double3x3 {
        translate(x: vector.x, y: vector.y)
    }
}
