//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import simd

public enum MatrixTransformation {
    public static func rotate(by angle: Angle) -> simd_double3x3 {
        let rows = [
            simd_double3( cos(angle.radians), sin(angle.radians), 0),
            simd_double3(-sin(angle.radians), cos(angle.radians), 0),
            simd_double3( 0,          0,          1)
        ]
        
        return double3x3(rows: rows)
    }
    
    public static func translate(x: Double, y: Double) -> simd_double3x3 {
        var matrix = matrix_identity_double3x3
            
        matrix[2, 0] = x
        matrix[2, 1] = y
        
        return matrix
    }
    
    public static func translate(vector: Vector) -> simd_double3x3 {
        translate(x: vector.x, y: vector.y)
    }
}
