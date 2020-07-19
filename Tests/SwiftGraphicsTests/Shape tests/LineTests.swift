//
//  LineTests.swift
//
//
//  Created by Emory Dunn on 2020-07-01.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class LineTests: XCTestCase {
    
    func testLength() {
        let line = Line(Vector(x: 0, y: 0), Vector(x: 0, y: 100))
        
        XCTAssertEqual(line.length, 100)
    }
    
    func testCenter() {
        let line = Line(0, 0, 100, 0)
        
        XCTAssertEqual(line.center, Vector(x: 50, y: 0))
    }
    
    func testPointOnLine() {
        let line = Line(0, 0, 100, 0)
        
        XCTAssertTrue(line.contains(line.center))
        XCTAssertTrue(line.contains(line.start))
        XCTAssertTrue(line.contains(line.end))
        
        XCTAssertFalse(line.contains(Vector(x: 50, y: 10)))
           
    }
    
    func testBoundingBox() {
        let line = Line(0, 0, 100, 100)
        
        XCTAssertEqual(
            line.boundingBox,
            Rectangle(x: 0, y: 0, width: 100, height: 100)
        )
    }
    
    func testNormal() {
        let line = Line(0, 0, 100, 100)
        
        XCTAssertEqual(
            line.normal(),
            Vector(x: -0.7071067811865476, y:  0.7071067811865476)
        )
    }
    
    func testAngle() {
        let line = Line(0, 0, 100, 100)
        
        print(line.slope())
        
        XCTAssertEqual(
            line.angle().toDegrees(),
            45
        )
    }
    
    func testLerp() {
        let line = Line(0, 0, 100, 100)
        
        XCTAssertEqual(
            line.lerp(0.5),
            Vector(x: 50, y: 50)
        )
    }
    
    func testPointAtDistance() {
        let line = Line(0, 0, 100, 100)
        
        XCTAssertEqual(
            line.point(at: 50),
            Vector(x: 35.35533905932738, y: 35.35533905932738)
        )

    }

    func testSlope() {
        let line = Line(0, 50, 100, 100)
        
        XCTAssertEqual(
            line.slope(),
            0.5
        )
    }
    
    func testLineIntersection() {
        let line1 = Line(0, 0, 100, 100)
        let line2 = Line(0, 100, 100, 0)
        
        XCTAssertEqual(
            line1.lineIntersection(line2),
            [Vector(x: 50, y: 50)]
        )
    }
    
    func testRayIntersection() {
        let line1 = Line(0, 0, 100, 100)

        XCTAssertEqual(
            line1.rayIntersection(origin: Vector(x: 0, y: 100), dir: Vector(angle: -45.toRadians())),
            Vector(x: 50.00000000000001, y: 50)
        )
        
        XCTAssertNil(line1.rayIntersection(origin: Vector(x: 0, y: 100), dir: Vector(angle: 45.toRadians())))
    }
    
    func testRayPlaneIntersection() {
        let line1 = Line(0, 0, 100, 100)
        let origin = Vector(x: 0, y: 100)

        
        XCTAssertEqual(
            line1.rayPlaneIntersection(origin: origin, dir: Vector(angle: -45.toRadians())),
            Vector(x: 50.00000000000001, y: 50)
        )
        
        XCTAssertNil(line1.rayPlaneIntersection(origin: origin, dir: Vector(angle: 50.toRadians())))
    }
    
}
