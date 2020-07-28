//
//  IntersectableTests.swift
//  
//
//  Created by Emory Dunn on 7/28/20.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class IntersectableTests: XCTestCase {
    
    func testPointDistrobution() {
        let shape = Circle(x: 100, y: 100, radius: 100)
        
        let points = shape.pointsDistributed(every: 90)
        
        print(points)
        XCTAssertEqual(
            points,
            [
                Vector(200.0, 100.0),
                Vector(100.0, 200.0),
                Vector(0, 100.00000000000001),
                Vector(99.99999999999999, 0.0)
            ])
    }
    
    func testLineIntersection() {
        
    }

}
