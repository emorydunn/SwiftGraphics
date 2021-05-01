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
        SwiftGraphicsContext.blendMode = .normal

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

        let line = Fresnel(500, 200, 600, 800)
        line.draw()

        // Draw an emitter
        SwiftGraphicsContext.strokeWeight = 1
        SwiftGraphicsContext.strokeColor = Color.red
        SwiftGraphicsContext.fillColor = .clear
        let emitter = DirectionalEmitter(x: 600, y: 300, direction: 125)
//        emitter.draw()
        emitter.run(objects: [
            bb,
            rect,
            circle,
            line
        ])
        emitter.draw()

        let svgTest = """
        <?xml version="1.0" encoding="UTF-8"?>
        <svg width="1000" height="1000" xmlns="http://www.w3.org/2000/svg" xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape">
            <style>
            line { mix-blend-mode: normal; }
            circle { mix-blend-mode: normal; }
            .vector { mix-blend-mode: normal; }
        </style>
            <rect x="50.0" y="50.0" width="900.0" height="900.0" stroke="#000000" stroke-opacity="0.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></rect>
            <rect x="200.0" y="300.0" width="150.0" height="300.0" stroke="#333333" stroke-opacity="1.0" stroke-width="1.0" fill="#000000" fill-opacity="0.0"></rect>
            <circle cx="400.0" cy="600.0" r="150.0" stroke="#000000" stroke-opacity="0.0" stroke-width="1.0" fill="#9BA0F0" fill-opacity="1.0"></circle>
            <line x1="500.0" y1="200.0" x2="600.0" y2="800.0" stroke="#333333" stroke-opacity="1.0" stroke-width="10.0"></line>
            <line x1="600.0" y1="300.0" x2="532.6884709962459" y2="396.1308259774755" stroke="#FF0000" stroke-opacity="1.0" stroke-width="1.0"></line>
            <line x1="532.6884709962459" y1="396.1308259774755" x2="350.0" y2="426.57890447684986" stroke="#FF0000" stroke-opacity="1.0" stroke-width="1.0"></line>
            <line x1="350.0" y1="426.57890447684986" x2="50.0" y2="504.57352800340243" stroke="#FF0000" stroke-opacity="1.0" stroke-width="1.0"></line>
        </svg>
        """.trimmingCharacters(in: .newlines)

        let svg = context.makeDoc().xmlString(options: [.documentTidyXML, .nodePreserveAttributeOrder, .nodePrettyPrint])

        XCTAssertEqual(svg, svgTest)

    }
}
