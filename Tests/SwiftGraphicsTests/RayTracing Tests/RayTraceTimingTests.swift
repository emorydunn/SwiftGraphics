//
//  CircleTests.swift
//
//
//  Created by Emory Dunn on 7/28/20.
//

import Foundation
import XCTest
import AppKit

@testable import SwiftGraphics

final class RayTraceTimingTests: XCTestCase {
    
    
    
    func testRaytraceTiming() {
        let sketch = RaytraceTestSketch()
        
        measure {
            sketch.raytraceAllEmitters()
        }

        
    }
    
    func testRenderTiming() {
        let sketch = RaytraceTestSketch()
        sketch.raytraceAllEmitters()
        measure {
            sketch.renderAllEmitters()
        }
        
    }
    
}
