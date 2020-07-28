//
//  PathTests.swift
//  
//
//  Created by Emory Dunn on 7/28/20.
//

import Foundation

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics


final class PathTests: XCTestCase {
    
    func testAddingPoints() {
        let path = Path()
        
        path.addPoint(Vector(100.0, 100.0))
        
        XCTAssertEqual(path.points.count, 1)
        
        path.addPoints([Vector(200.0, 200.0)])
        
        XCTAssertEqual(path.points.count, 2)
        
        path.addPoints(Path(points: [Vector(300.0, 300.0)]))
        
        XCTAssertEqual(path.points.count, 3)
    }
    
    func testSmoothLine() {
        let path = Path(points: [Vector(100.0, 100.0), Vector(200.0, 200.0), Vector(300.0, 100.0)])
        
        let bezier: [Path.BezierPoint] = path.smoothLine()
        
        XCTAssertEqual(
            bezier,
            [
                Path.BezierPoint(point: Vector (200.0, 200.0),
                                 control1: Vector (120.0, 120.0),
                                 control2: Vector (160.0, 200.0)),
                Path.BezierPoint(point: Vector (300.0, 100.0),
                                 control1: Vector (240.0, 200.0),
                                 control2: Vector (280.0, 120.0))

        ])

        
    }
    
    // MARK: - Hashable Tests
    
    func testEquality() {
        XCTAssertEqual(Path(), Path())
    }
    
    func testHashable() {
        XCTAssertEqual(Path().hashValue, Path().hashValue)
    }
    
}

