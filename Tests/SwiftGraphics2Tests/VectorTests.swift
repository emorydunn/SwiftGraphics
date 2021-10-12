//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import XCTest
import simd
@testable import SwiftGraphics2

final class VectorTests: XCTestCase {
    
    func testTranslation() {
        
        let vector = Vector(3, 2, 1)
        
        let transformation = MatrixTransformation.translate(x: 1, y: 3)
        
        print(vector)
        print(transformation)
        
        let newVector = Vector(transformation * vector.simdVector)
        
        XCTAssertEqual(newVector, Vector(4, 5))

    }
    
    func testRotation() {
        measure {
            var vector = Vector(4, 5, 1)
            vector.rotate(by: .degrees(30))
        }
        
    }
    
    func testTransform() {
        let transMatrix = MatrixTransformation.translate(x: 20, y: 30)
        let rotMatrix = MatrixTransformation.rotate(by: .degrees(30))
        let compoundMatrix = transMatrix * rotMatrix
        
        let vect = Vector(10, 5, transformation: compoundMatrix)
        
        XCTAssertEqual(vect, Vector(31.16025403784439, 29.330127018922195))
    }
    
    func testMarixRotation() {
        measure {
            var vector = Vector(4, 5, 1)
            vector.matrixRotate(by: .degrees(30))
        }
    }
    
    func testMeasureCross() {
        measure {
            let vector = Vector(4, 5)
            let vector2 = Vector(14, 15)
            
            vector.cross(vector2)
        }
    }
    
    func testMeasureCross2() {
        measure {
            let vector = Vector(4, 5)
            let vector2 = Vector(14, 15)
            
            vector.cross2(vector2)
        }
    }
    
}
