//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/10/21.
//

import Foundation
import simd


public protocol Polygon {
    var origin: Vector { get set }
    var rotation: Angle { get set }
    
    var points: [Vector] { get }
}

extension Polygon {
    var boundingBox: Rectangle {
        var maxX = Double.zero
        var maxY = Double.zero
        var minX = Double.infinity
        var minY = Double.infinity
        
        points.forEach {
            maxX = max($0.x, maxX)
            maxY = max($0.y, maxY)
            minX = min($0.x, minX)
            minY = min($0.y, minY)
        }
        
        return Rectangle(origin: origin, height: maxY - minY, width: maxX - minX)

    }
}
//public struct Polygon {
//    var points: [Vector]
//
////    func makeRotationMatrix(angle: Double) -> simd_double3x3 {
////        let rows = [
////            simd_double3( cos(angle), sin(angle), 0),
////            simd_double3(-sin(angle), cos(angle), 0),
////            simd_double3( 0,          0,          1)
////        ]
////
////        return double3x3(rows: rows)
////    }
////
//    mutating func rotate(by angle: Angle) {
//        let quat = simd_quatd(MatrixTransformation.rotate(by: angle))
//        for var vector in points {
//
////            vector.simdVector = quat.act(vector.simdVector)
//        }
//    }
//
//    func contains(point: Vector) -> Bool {
//        windingNumber(of: point, polygon: points)
//    }
//}
