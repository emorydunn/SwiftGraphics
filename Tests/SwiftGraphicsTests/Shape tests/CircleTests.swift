//
//  File.swift
//  
//
//  Created by Emory Dunn on 7/28/20.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

extension Circle {
    static let defaultCircle = Circle(x: 100, y: 100, radius: 100)
}

final class CircleTests: XCTestCase {
    
    func testComputedVars() {
        let circle = Circle.defaultCircle
        circle.radiusOffset = 20
        
        XCTAssertEqual(circle.diameter, 200)
        XCTAssertEqual(circle.offsetRadius, 120)
        XCTAssertEqual(circle.offsetDiameter, 240)
    }
    
    func testBoundingBox() {
        let circle = Circle.defaultCircle
        
        XCTAssertEqual(circle.boundingBox, Rectangle(x: 0, y: 0, width: 200, height: 200))
    }
    
    // MARK: - Intersectable
    func testRayIntersection() {
        let circle = Circle.defaultCircle
        
        XCTAssertEqual(circle.rayIntersection(0), Vector(x: 200, y: 100))
    }
    
    func testRayIntersectionOrigin() {
        let circle = Circle.defaultCircle
        
        XCTAssertEqual(
            circle.rayIntersection(origin: Vector(x: 300, y: 300), dir: Vector(angle: 225.toRadians())),
            
            Vector(x: 170.71067811865476, y: 170.71067811865476)
        )
        
        XCTAssertNil(circle.rayIntersection(origin: Vector(x: 300, y: 300), dir: Vector(angle: 0.toRadians())))
    }
    
    func testRayIntersectionObjects() {
        XCTAssertTrue(Circle.defaultCircle.intersections(for: 0, origin: Vector(x: 300, y: 300), objects: []).isEmpty)
    }
    
    func testLineIntersection() {
        let line = Line(0, 0, 200, 200)
        let points = Circle.defaultCircle.lineIntersection(line)
        
        XCTAssertEqual(points.count, 2)
    }
    
    func testContainsPoint() {
        XCTAssertTrue(Circle.defaultCircle.contains(Vector(150.0, 150.0)))
    }
    
    // MARK: - Hashable
    func testEquality() {
        XCTAssertEqual(
            Circle.defaultCircle,
            Circle(center: Vector(100.0, 100.0), radius: 100))
    }
    
    func testHashable() {

        XCTAssertEqual(
            Circle.defaultCircle.hashValue,
            Circle(center: Vector(100.0, 100.0), radius: 100).hashValue)
    }

}
