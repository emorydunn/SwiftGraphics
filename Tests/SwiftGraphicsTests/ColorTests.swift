//
//  CGColorTests.swift
//  
//
//  Created by Emory Dunn on 5/22/20.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class ColorTests: XCTestCase {
    
    func testHex() {
        let grey = Color(grey: 0.5, 1)
        let red = Color(1.0, 0.0, 0.0, 1)
        let color = Color(155, 160, 240, 1)

        XCTAssertEqual(grey.toHex(), "#808080")
        XCTAssertEqual(red.toHex(), "#FF0000")
        XCTAssertEqual(color.toHex(), "#9BA0F0")
    }
    
    func testRGBA() {
        let grey = Color(grey: 0.5, 1)
        let red = Color(1.0, 0.0, 0.0, 1)
        let color = Color(155, 160, 240, 1)
        let clear = Color.clear
        
        XCTAssertEqual(grey.toRGBA(), "rgba(128, 128, 128, 1.0)")
        XCTAssertEqual(red.toRGBA(), "rgba(255, 0, 0, 1.0)")
        XCTAssertEqual(color.toRGBA(), "rgba(155, 160, 240, 1.0)")
        XCTAssertEqual(clear.toRGBA(), "rgba(0, 0, 0, 0.0)")
    }
    
    static var allTests = [
        ("testHex", testHex),
    ]
}


