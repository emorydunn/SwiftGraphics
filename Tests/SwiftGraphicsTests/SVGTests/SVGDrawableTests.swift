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
    
    func testCircle() {
        
        let shape = Circle(x: 100, y: 200, radius: 75)
        let xml = shape.svgElement()

        XCTAssertEqual(
            makeXMLString(xml),
            #"<circle cx="100.0" cy="200.0" r="75.0" stroke="rgba(0,0,0,1.0)" stroke-width="1.0" fill="rgba(0,0,0,0.0)"></circle>"#
            )
        
    }
    
    func testRect() {
        
        let shape = Rectangle(x: 100, y: 200, width: 300, height: 400)
        let xml = shape.svgElement()
        
        XCTAssertEqual(
            makeXMLString(xml),
            #"<rect x="100.0" y="200.0" width="300.0" height="400.0" stroke="rgba(0,0,0,1.0)" stroke-width="1.0" fill="rgba(0,0,0,0.0)"></rect>"#
        )
        
    }
    
    func testLine() {
        
        let shape = Line(100, 200, 300, 400)
        let xml = shape.svgElement()
        
        XCTAssertEqual(
            makeXMLString(xml),
            #"<line x1="100.0" y1="200.0" x2="300.0" y2="400.0" stroke="rgba(0,0,0,1.0)" stroke-width="1.0"></line>"#
        )
        
    }
    
}
