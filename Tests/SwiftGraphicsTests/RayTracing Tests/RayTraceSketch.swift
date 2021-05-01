//
//  File.swift
//  
//
//  Created by Emory Dunn on 4/15/21.
//

import Foundation
import SwiftGraphics

// This is now a finalized sketch, please make a new one to test with
class RaytraceTestSketch: Sketch {

    static var title = "RaytraceTestSketch"
    
    public var size = Size(width: 1000, height: 1000)
    
    var loop: SketchAnimation = .none

    var tracingObjects: [RayTracable] = []
    
    var bb: Rectangle!
    var emitterRed: CircleEmitter!
    var emitterGreen: CircleEmitter!
    var emitterBlue: CircleEmitter!
    
    required public init() {
        print("\(#file) \(#function)")
        
        addObjects()

    }
    
    func addObjects() {
        print("\(#file) \(#function)")
        
        bb = Rectangle(x: 0, y: 0, width: size.width, height: size.height)
        tracingObjects.append(bb)

        // Add objects
        let circle = Circle(x: 450, y: 250, radius: 100)
        tracingObjects.append(circle)
        
        let circle2 = Circle(x: 875, y: 500, radius: 75)
        tracingObjects.append(circle2)
        
        let rect = Rectangle(x: 200, y: 700, width: 200, height: 100)
        tracingObjects.append(rect)
        
        let f2 = Fresnel(800, 1000-700, 600, 1000-850) // swiftlint:disable:this identifier_name
        tracingObjects.append(f2)
        
        let f3 = Fresnel(600, 1000-300, 700, 1000-500) // swiftlint:disable:this identifier_name
        tracingObjects.append(f3)
        
        let f4 = Fresnel(150, 1000-450, 500, 1000-400) // swiftlint:disable:this identifier_name
        tracingObjects.append(f4)
    
        // Add emitters
        let rayStep = 3600
        emitterRed = CircleEmitter(x: 600, y: 1000-600, radius: 50, rayStep: rayStep)
        tracingObjects.append(emitterRed)
        
        emitterGreen = CircleEmitter(x: 650, y: 1000-200, radius: 50, rayStep: rayStep)
        tracingObjects.append(emitterGreen)

        emitterBlue = CircleEmitter(x: 155, y: 1000-520, radius: 50, rayStep: rayStep)
        tracingObjects.append(emitterBlue)
    }
    
    
    func draw() {
        drawBackground()
        
        SwiftGraphicsContext.blendMode.setCGBlenMode()

        renderEmitter(
            emitterRed,
            fill: .red,
            stroke: .init(255, 0, 0, 0.33)
        )
        
        renderEmitter(
            emitterGreen,
            fill: .green,
            stroke: .init(0, 255, 0, 0.33)
        )
        
        renderEmitter(
            emitterBlue,
            fill: .blue,
            stroke: .init(0, 0, 255, 0.33)
        )
        
    }
    
    func raytrace(_ emitter: CircleEmitter) {
        emitter.run(objects: tracingObjects)
    }
    
    func raytraceAllEmitters() {
        raytrace(emitterRed)
        raytrace(emitterGreen)
        raytrace(emitterBlue)
    }
    
    func renderAllEmitters() {
        renderEmitter(
            emitterRed,
            fill: .red,
            stroke: Color(255, 0, 0, 0.33)
        )
        
        renderEmitter(
            emitterGreen,
            fill: .green,
            stroke: Color(0, 255, 0, 0.33)
        )
        
        renderEmitter(
            emitterBlue,
            fill: .blue,
            stroke: Color(0, 0, 255, 0.33)
        )
        
    }
    
    func renderEmitter(_ emitter: CircleEmitter, fill: Color, stroke: Color) {

        SwiftGraphicsContext.strokeColor = stroke
        print("Drawing color pass")
        emitter.draw()
        
    }
    
}
