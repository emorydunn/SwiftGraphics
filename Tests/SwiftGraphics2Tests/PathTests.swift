//
//  PathTests.swift
//  
//
//  Created by Emory Dunn on 3/3/22.
//

import Foundation
import XCTest
@testable import SwiftGraphics2

final class PathTests: XCTestCase {
    
    func testLineLerp() {
        let path = Path(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100)
        )

        let point = path.lerp(percent: 0.5)
        
        XCTAssertEqual(point, Vector(118.46854449606303, 56.91280140577422))

    }
    
}
