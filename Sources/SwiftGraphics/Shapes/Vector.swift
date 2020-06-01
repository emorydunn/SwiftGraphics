//
//  Point.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

public class Vector: Shape {
    public var x: Double
    public var y: Double
    public var z: Double
    
    public init(x: Double, y: Double, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ x: Double, _ y: Double, _ z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat = 0) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }
    
    public init(angle: Radians) {
        self.x = cos(angle)
        self.y = sin(angle)
        self.z = 0
    }
    
    public func set(_ v: Vector) {
        self.x = v.x
        self.y = v.y
        self.z = v.z
    }
    
    public func copy() -> Vector {
        return Vector(self.x, self.y, self.z)
    }
    
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
    
    public var boundingBox: Rectangle {
        Rectangle(x: x, y: y, width: 1, height: 1)
    }
    
    public func nsPoint() -> NSPoint {
        NSPoint(x: x, y: y)
    }
    
}

// MARK: - Static Vector Math Functions
extension Vector {
    public static func add(_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(
            v1.x + v2.x,
            v1.y + v2.y,
            v1.z + v2.z
        )
    }
    
    public static func sub (_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
    }
    
    public static func mult(_ v: Vector, _ n: Double) -> Vector {
        return Vector(v.x * n, v.y * n, v.z * n)
    }
    
    public static func div(_ v: Vector, _ n: Double) -> Vector {
        return Vector(v.x / n, v.y / n, v.z / n)
    }
    
    public static func dist(_ v1: Vector, _ v2: Vector) -> Double {
        return sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2) + pow(v2.z - v1.z, 2))
    }
    
    public static func dot(_ v1: Vector, _ v2: Vector) -> Double {
        return v1.x * v2.x + v2.y * v2.y + v1.z * v2.z
    }
    
    public static func cross(_ v1: Vector, _ v2: Vector) -> Vector {
        let x = v1.y * v2.z - v1.z * v2.y
        let y = v1.z * v2.x - v1.x * v2.z
        let z = v1.x * v2.y - v1.y * v2.x
        
        return Vector(x, y, z)
    }
    
}

// MARK: - Vector Math Functions
extension Vector {
    public func add(_ v: Vector) {
        self.x += v.x
        self.y += v.y
        self.z += v.z
    }
    
    public func sub(_ v: Vector) {
        self.x -= v.x
        self.y -= v.y
        self.z -= v.z
    }
    
    public func mult(_ n: Double) {
        let result = Vector.mult(self, n)
        self.set(result)
    }
    
    public func div(_ n: Double) {
        let result = Vector.div(self, n)
        self.set(result)
    }
    
    public func mag() -> Double {
        return sqrt(self.magSq())
    }
    
    public func magSq() -> Double {
        return x * x + y * y + z * z
    }
    
    public func dist(_ v: Vector) -> Double {
        return Vector.dist(v, self)
    }
    
    public func dot(_ v: Vector) -> Double {
        return Vector.dot(self, v)
    }
    
    public func cross(_ v: Vector) -> Vector {
        return Vector.cross(self, v)
    }
    
    public func normalize() {
        let len = self.mag()
        if (len != 0) {
            self.mult(1 / len)
        }
    }
    
//    public func normal() {
//        let u = -y
//        let v = x
//    }
    
    public func angleBetween(_ v: Vector) -> Double {
        let dotmagmag = self.dot(v) / (self.mag() * v.mag())
        // Mathematically speaking: the dotmagmag variable will be between -1 and 1
        // inclusive. Practically though it could be slightly outside this range due
        // to floating-point rounding issues. This can make Math.acos return NaN.
        //
        // Solution: we'll clamp the value to the -1,1 range
        
        var angle = acos(min(1, max(-1, dotmagmag)))
        angle = angle * sign(self.cross(v).z)
        
        return angle
        
    }
    
    func sign(_ num: Double) -> Double {
        return num >= 0 ? 1 : -1
    }
    
    public func heading() -> Radians {
        return atan2(self.y, self.x)
    }
    
    public func rotate(by theta: Radians) {
        let newHeading = self.heading() + theta
        rotate(to: newHeading)
//        self.x = cos(newHeading) * mag()
//        self.y = sin(newHeading) * mag()
        
    }
    
    public func rotate(to theta: Radians) {
        let newHeading = theta
        
        self.x = cos(newHeading) * mag()
        self.y = sin(newHeading) * mag()
        
    }
}

extension Vector: CGDrawable {
    public func draw(in context: CGContext) {
        Rectangle(x: x, y: y, width: 1, height: 1).draw(in: context)
//        context.setStrokeColor(strokeColor)
//        context.setFillColor(fillColor)
//        context.setLineWidth(CGFloat(strokeWeight))
//        let rect = CGRect(x: x, y: y, width: 1, height: 1)
        
//        context.fill(rect)
    }
    
    public func debugDraw(in context: CGContext) {
//        draw(in: context)
        Circle(center: self, radius: 5).draw(in: context)
    }
}


extension Vector: SVGDrawable {
    public func svgElement() -> XMLElement {
        let rect = Rectangle(x: x, y: y, width: 1, height: 1).svgElement()
        rect.addAttribute("vector", forKey: "class")
        
        return rect
    }
}

extension Vector: CustomStringConvertible {
    public var description: String {
        "Vector (\(x), \(y))"
    }
}
