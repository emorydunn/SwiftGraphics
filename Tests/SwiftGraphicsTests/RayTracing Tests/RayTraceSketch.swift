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
    
    
//    var objects: [Motion] = []
    var tracingObjects: [RayTracable] = []
    
    var bb: Rectangle!
    var emitterRed: CircleEmitter!
    var emitterGreen: CircleEmitter!
    var emitterBlue: CircleEmitter!
    
    required public init() {
        print("\(#file) \(#function)")
        
        addObjects()
        
        SwiftGraphicsContext.blendMode = .lighten
        
    }
    
    func addObjects() {
        print("\(#file) \(#function)")
        
        bb = Rectangle(x: 0, y: 0, width: size.width, height: size.height)
        tracingObjects.append(bb)
//        objects.append(Motion(bb))
        
        // Add objects
        let circle = Circle(x: 450, y: 250, radius: 100)
        tracingObjects.append(circle)
//        objects.append(Motion(circle))
        
        let circle2 = Circle(x: 875, y: 500, radius: 75)
        tracingObjects.append(circle2)
//        objects.append(Motion(circle2))
        
        let rect = Rectangle(x: 200, y: 700, width: 200, height: 100)
        tracingObjects.append(rect)
//        objects.append(Motion(rect))
        
        let f2 = Fresnel(800, 1000-700, 600, 1000-850) // swiftlint:disable:this identifier_name
        tracingObjects.append(f2)
        //        objects.append(Motion(f2))
        
        let f3 = Fresnel(600, 1000-300, 700, 1000-500) // swiftlint:disable:this identifier_name
        tracingObjects.append(f3)
        //        objects.append(Motion(f3))
        
        let f4 = Fresnel(150, 1000-450, 500, 1000-400) // swiftlint:disable:this identifier_name
        tracingObjects.append(f4)
        //        objects.append(Motion(f4))
        
        // Add emitters
        let rayStep = 3600
        emitterRed = CircleEmitter(x: 600, y: 1000-600, radius: 50, rayStep: rayStep)
        tracingObjects.append(emitterRed)
//        objects.append(Motion(emitterRed))
        
        emitterGreen = CircleEmitter(x: 650, y: 1000-200, radius: 50, rayStep: rayStep)
        tracingObjects.append(emitterGreen)
//        objects.append(Motion(emitterGreen))
        
        emitterBlue = CircleEmitter(x: 155, y: 1000-520, radius: 50, rayStep: rayStep)
        tracingObjects.append(emitterBlue)
//        objects.append(Motion(emitterBlue))
    }
    
    func drawBackground() {
        SwiftGraphicsContext.fillColor = Color(grey: 0.2, 1)
        Rectangle(x: 0, y: 0, width: size.width, height: size.height).draw()
        //        BoundingBox(inset: 0).draw()
    }
    
    func draw() {
        //        print("\(#file) \(#function)")
        drawBackground()
        //        bb.update()
        
        //        SwiftGraphicsContext.blendMode = .lighten
        SwiftGraphicsContext.blendMode.setCGBlenMode()
        //        NSGraphicsContext.current?.cgContext.setBlendMode(.lighten)
        
//        objects.forEach {
//            if $0.object === bb {
//                return
//            }
//            $0.updatePosition()
//            $0.handleCollisions(with: objects, inside: bb)
//            //            $0.debugDraw()
//
//        }
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

//        SwiftGraphicsContext.strokeColor = Color(grey: 1, 0.05)
//        print("Drawing white pass")
//        emitter.draw()
        
        SwiftGraphicsContext.strokeColor = stroke
        print("Drawing color pass")
        emitter.draw()
        
    }
    
}
