//
//  Rectangletests.swift
//
//
//  Created by Emory Dunn on 2020-07-01.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class RectangleTests: XCTestCase {
    
    func testCornerInit() {
        let rect = Rectangle(x: 100, y: 200, width: 100, height: 200)
        
        XCTAssertEqual(rect.x, 100)
        XCTAssertEqual(rect.y, 200)
        XCTAssertEqual(rect.width, 100)
        XCTAssertEqual(rect.height, 200)
    }
    
    func testCenterInit() {
        let rect = Rectangle(centerX: 100, centerY: 200, width: 100, height: 200)
        
        XCTAssertEqual(rect.x, 50)
        XCTAssertEqual(rect.y, 100)
        XCTAssertEqual(rect.width, 100)
        XCTAssertEqual(rect.height, 200)
    }
    
    func testCenter() {
        let rect = Rectangle(x: 100, y: 200, width: 100, height: 200)
        
        XCTAssertEqual(rect.center.x, 150)
        XCTAssertEqual(rect.center.y, 300)
        
        rect.center = Vector(x: 20, y: 20)
        
        XCTAssertEqual(rect.x, -30)
        XCTAssertEqual(rect.y, -80)
    }
    
    func testMinAndMax() {
        let rect = Rectangle(x: 100, y: 200, width: 100, height: 200)
        
        XCTAssertEqual(rect.minX, 100)
        XCTAssertEqual(rect.maxX, 200)
        
        XCTAssertEqual(rect.minY, 200)
        XCTAssertEqual(rect.maxY, 400)
        
    }
    
    func testCorners() {
        let rect = Rectangle(x: 100, y: 200, width: 100, height: 200)
        
        XCTAssertEqual(rect.topLeft.x, 100)
        XCTAssertEqual(rect.topLeft.y, 200)
        
        XCTAssertEqual(rect.topRight.x, 200)
        XCTAssertEqual(rect.topRight.y, 200)
        
        XCTAssertEqual(rect.bottomLeft.x, 100)
        XCTAssertEqual(rect.bottomLeft.y, 400)
        
        XCTAssertEqual(rect.bottomRight.x, 200)
        XCTAssertEqual(rect.bottomRight.y, 400)

    }
    
    func testEdges() {
        let rect = Rectangle(x: 100, y: 200, width: 100, height: 200)
        
        
        XCTAssertEqual(
            rect.topEdge,
            Line(100, 200, 200, 200)
        )
        
        XCTAssertEqual(
            rect.bottomEdge,
            Line(100, 400, 200, 400)
        )
        
        XCTAssertEqual(
            rect.leftEdge,
            Line(100, 200, 100, 400)
        )
        
        XCTAssertEqual(
            rect.rightEdge,
            Line(200, 200, 200, 400)
        )
        
    }
    
    
    
}
