//
//  File.swift
//  
//
//  Created by Emory Dunn on 10/11/21.
//

import Foundation
import XCTest
@testable import SwiftGraphics2

final class PolygonTests: XCTestCase {
    
    func testPolygon() {

        let polygon = Rectangle(center: Vector(20, 30), width: 20, height: 10)
        
        XCTAssertEqual(polygon.points, [
            Vector(10, 25),
            Vector(30, 25),
            Vector(30, 35),
            Vector(10, 35)
        ])

    }
    
    func testRotate() {

        measure {
            let polygon = Rectangle(center: Vector(20, 30), width: 20, height: 10, rotation: .degrees(30))
            
            XCTAssertEqual(polygon.points, [
                Vector(8.839745962155613, 30.669872981077805),
                Vector(26.16025403784439, 20.66987298107781),
                Vector(31.16025403784439, 29.330127018922195),
                Vector(13.839745962155613, 39.33012701892219)
            ])
        }

    }
    
    func testBoundingBox() {
        
        let polygon = Rectangle(center: Vector(20, 30), width: 20, height: 10, rotation: .degrees(30))

        measure {

            XCTAssertEqual(polygon.boundingBox.points, [
                Vector(8.839745962155611, 20.66987298107781),
                Vector(31.16025403784439, 20.66987298107781),
                Vector(31.16025403784439, 39.33012701892219),
                Vector(8.839745962155611, 39.33012701892219)
            ])
        }

    }
    
}

