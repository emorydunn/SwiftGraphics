//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/24/22.
//

import Foundation
import XCTest
@testable import SwiftGraphics2

final class SVGRectangleTests: XCTestCase {
    
    func testSVG() {
        let rect = Rectangle(centerX: 100, y: 100, width: 100, height: 100)
            .strokeColor(nil)
        
        
        let svg = rect.svgElement()!
        
        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<rect x="50.0" y="50.0" width="100.0" height="100.0" stroke="none" fill="none"></rect>"#)
    }
    
    func testSVG_Rotated() {
        let rect = Rectangle(centerX: 100, y: 100, width: 100, height: 100, rotation: .degrees(45))
        
        let svg = rect.svgElement()!
        
        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<rect x="50.0" y="50.0" width="100.0" height="100.0" transform="rotate(45.0,100.0,100.0)" stroke="none" fill="none"></rect>"#)
    }
    
    func testSVG_PointOrder() {
        let rect = Rectangle(centerX: 100, y: 100, width: 100, height: 100, rotation: .degrees(0))
        
        let svg = Path(rect.points).svgElement()!
        
        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<polyline points="50.0,50.0 150.0,50.0 150.0,150.0 50.0,150.0" stroke="none" fill="none"></polyline>"#)
    }
}

final class SVGCircleTests: XCTestCase {
    
    func testSVG() {
        let shape = Circle(x: 100, y: 150, radius: 75)
        
        let svg = shape.svgElement()!
        
        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<circle cx="100.0" cy="150.0" r="75.0" stroke="none" fill="none"></circle>"#)
    }

}

final class SVGLineTests: XCTestCase {
    
    func testSVG() {
        let shape = Line(100, 100, 200, 200)
        
        let svg = shape.svgElement()!
        
        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<line x1="100.0" y1="100.0" x2="200.0" y2="200.0" stroke="none"></line>"#)
    }

}

final class SVGPathTests: XCTestCase {
    
    func testSVG() {
        let shape = Path(Vector(100, 100), Vector(200, 200), Vector(300, 100))
        
        let svg = shape.svgElement()!
        
        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       ##"<polyline points="100.0,100.0 200.0,200.0 300.0,100.0" stroke="none" fill="none"></polyline>"##)
    }

}

final class SVGBezierPathTests: XCTestCase {
    
    func testSVG() {
        
        let path = BezierPath(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100),
            Vector(375, 120)
        )

        let svg = path.svgElement()!

        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<path d="M 55.0,150.0 C 130.0,40.0 200.0,100.0 375.0,120.0" stroke="none" fill="none"></path>"#)
    }
    
    func testThreePoint() {
        
        let path = BezierPath(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100)
        )

        let svg = path.svgElement()!

        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<path d="M 55.0,150.0 Q 130.0,40.0 200.0,100.0" stroke="none" fill="none"></path>"#)
    }
    
    func testDebugSVG() {
        
        let path = BezierPath(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100),
            Vector(375, 120)
        )

        let svg = path.debugSVG()!

        XCTAssertEqual(svg.xmlString(options: .documentTidyXML),
                       #"<g><polyline points="55.0,150.0 130.0,40.0 200.0,100.0 375.0,120.0" stroke="none" fill="none"></polyline><path d="M 55.0,150.0 C 130.0,40.0 200.0,100.0 375.0,120.0" stroke="none" fill="none"></path></g>"#)
    }

}
