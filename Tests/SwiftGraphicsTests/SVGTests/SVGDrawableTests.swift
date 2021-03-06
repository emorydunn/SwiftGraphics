//
//  SVGDrawableTests.swift
//
//
//  Created by Emory Dunn on 5/22/20.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class SVGDrawableTests: XCTestCase {

    func makeXMLString(_ element: XMLElement) -> String {
        let doc = XMLDocument(rootElement: element)
        return doc.xmlString(options: [.documentTidyXML, .nodePreserveAttributeOrder])
    }

    func setTestContext() {
        SwiftGraphicsContext.fillColor = .clear
        SwiftGraphicsContext.strokeColor = .black
        SwiftGraphicsContext.strokeWeight = 1
    }

    func testCircle() {

        setTestContext()

        let shape = Circle(x: 100, y: 200, radius: 75)
        let xml = shape.svgElement()

        XCTAssertEqual(
            makeXMLString(xml),
            ##"<circle cx="100.0" cy="200.0" r="75.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></circle>"##
            )

    }

    func testRect() {

        setTestContext()

        let shape = Rectangle(x: 100, y: 200, width: 300, height: 400)
        let xml = shape.svgElement()

        XCTAssertEqual(
            makeXMLString(xml),
            ##"<rect x="100.0" y="200.0" width="300.0" height="400.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></rect>"##
        )

    }

    func testLine() {

        setTestContext()

        let shape = Line(100, 200, 300, 400)
        let xml = shape.svgElement()

        XCTAssertEqual(
            makeXMLString(xml),
            ##"<line x1="100.0" y1="200.0" x2="300.0" y2="400.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0"></line>"##
        )

    }
    
    
    func testPath() {
        
        let path = Path(points: [Vector(100.0, 100.0), Vector(200.0, 200.0), Vector(300.0, 100.0)])
    
        let sharpXML: XMLElement = path.svgElement()
        XCTAssertEqual(
            makeXMLString(sharpXML),
            ##"<path d="M 100.0,100.0 L 100.0 100.0 L 200.0 200.0 L 300.0 100.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></path>"##
        )
        
    }
    
    func testBezierPath() {
        setTestContext()
        
        let path = BezierPath(Path(points: [Vector(100.0, 100.0), Vector(200.0, 200.0), Vector(300.0, 100.0)]))
        
        let smoothXML: XMLElement = path.svgElement()
        XCTAssertEqual(
            makeXMLString(smoothXML),
            ##"<path d="M 100.0,100.0 C 120.0,120.0 160.0,200.0 200.0,200.0 C 240.0,200.0 280.0,120.0 300.0,100.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></path>"##
        )
        
    }

    func testBoundingBox() {

        setTestContext()
        SwiftGraphicsContext.current = SVGContext(width: 500, height: 500)

        let shape = BoundingBox(inset: 100)
        shape.update()
        let xml = shape.svgElement()

        XCTAssertEqual(
            makeXMLString(xml),
            ##"<rect x="100.0" y="100.0" width="300.0" height="300.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></rect>"##
        )

    }

    func testVector() {

        setTestContext()

        let shape = Vector(100.0, 100.0)
        let xml = shape.svgElement()

        XCTAssertEqual(
            makeXMLString(xml),
            ##"<rect x="100.0" y="100.0" width="1.0" height="1.0" stroke="#000000" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0" class="vector"></rect>"##
        )

    }

}
