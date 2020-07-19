//
//  SVGContextTests.swift
//
//
//  Created by Emory Dunn on 5/22/20.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class SVGContextTests: XCTestCase {
    
    func testDrawing() {
        let context = SVGContext(width: 1000, height: 1000)
        
        SwiftGraphicsContext.current = context
        
        // Draw an invisible boundingbox
        SwiftGraphicsContext.fillColor = .clear
        SwiftGraphicsContext.strokeColor = .clear
        let bb = BoundingBox(inset: 50)
        bb.draw()
        
        // Draw a grey stroked rect
        SwiftGraphicsContext.fillColor = .clear
        SwiftGraphicsContext.strokeColor = Color(grey: 0.2, 1)
        let rect = Rectangle(x: 200, y: 300, width: 150, height: 300)
        rect.draw()
        
        // Draw a filled circle
        SwiftGraphicsContext.fillColor = Color(155, 160, 240, 1)
        SwiftGraphicsContext.strokeColor = .clear
        let circle = Circle(x: 400, y: 600, radius: 150)
        circle.draw()
        
        // Draw a thick line
        SwiftGraphicsContext.strokeWeight = 10
        SwiftGraphicsContext.strokeColor = Color(grey: 0.2, 1)
        
        let line = Fresnel(600, 800, 500, 200)
        line.draw()
        
        // Draw an emitter
        SwiftGraphicsContext.strokeWeight = 1
        SwiftGraphicsContext.strokeColor = Color.red
        SwiftGraphicsContext.fillColor = .clear
        let e = DirectionalEmitter(x: 600, y: 300, direction: 125)
        e.draw()
        e.draw(
            objects: [
                rect,
                circle,
                line
        ])
        
        let svgTest = """
        <?xml version="1.0" encoding="UTF-8"?>
        <svg width="1000" height="1000" xmlns="http://www.w3.org/2000/svg">
            <style>
            line { mix-blend-mode: normal; }
            circle { mix-blend-mode: normal; }
            .vector { mix-blend-mode: normal; }
            </style>
            <rect x="50.0" y="50.0" width="900.0" height="900.0" stroke="rgba(0,0,0,0.0)" stroke-width="1.0" fill="rgba(0,0,0,0.0)"></rect>
            <rect x="200.0" y="300.0" width="150.0" height="300.0" stroke="rgba(51,51,51,1.0)" stroke-width="1.0" fill="rgba(0,0,0,0.0)"></rect>
            <circle cx="400.0" cy="600.0" r="150.0" stroke="rgba(0,0,0,0.0)" stroke-width="1.0" fill="rgba(155,160,240,1.0)"></circle>
            <line x1="600.0" y1="800.0" x2="500.0" y2="200.0" stroke="rgba(51,51,51,1.0)" stroke-width="10.0"></line>
            <circle cx="600.0" cy="300.0" r="10.0" stroke="rgba(255,0,0,1.0)" stroke-width="1.0" fill="rgba(0,0,0,0.0)"></circle>
            <line x1="600.0" y1="300.0" x2="532.6884709962459" y2="396.1308259774755" stroke="rgba(255,0,0,1.0)" stroke-width="1.0"></line>
            <line x1="532.6884709962459" y1="396.1308259774755" x2="350.0" y2="426.57890447684986" stroke="rgba(255,0,0,1.0)" stroke-width="1.0"></line>
        </svg>
        """.trimmingCharacters(in: .newlines)
        
        let svg = context.makeDoc().xmlString(options: [.documentTidyXML, .nodePreserveAttributeOrder, .nodePrettyPrint])
        
        XCTAssertEqual(svg, svgTest)
        
    }
}
