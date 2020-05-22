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

final class CGColorTests: XCTestCase {
    
    func testHex() {
        let grey = CGColor(gray: 0.5, alpha: 1)
        let red = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        let color = CGColor(red: 155/255, green: 160/255, blue: 240/255, alpha: 1)

        XCTAssertEqual(grey.toHex(), "#808080")
        XCTAssertEqual(red.toHex(), "#FF0000")
        XCTAssertEqual(color.toHex(), "#9BA0F0")
    }
    
    static var allTests = [
        ("testHex", testHex),
    ]
}
