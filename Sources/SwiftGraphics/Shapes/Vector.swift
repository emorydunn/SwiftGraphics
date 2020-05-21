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
    public var z: Double?
    
    public init(x: Double, y: Double, z: Double? = nil) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ x: Double, _ y: Double, _ z: Double? = nil) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat? = nil) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = z == nil ? nil : Double(z!)
    }
    
    public func set(_ v: Vector) {
        self.x = v.x
        self.y = v.y
        self.z = v.z
    }
    
    public func copy() -> Vector {
        return Vector(self.x, self.y, self.z)
    }
    
    public func draw() {
        let rect = CGRect(x: x, y: y, width: 1, height: 1)
        context?.fill(rect)
    }
    
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
    
}

// MARK: - Static Vector Math Functions
extension Vector {
    public static func add(_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(v1.x + v2.x, v1.y + v2.y, v1.z != nil ? (v1.z! + v2.z!) : nil)
    }
    
    public static func sub (_ v1: Vector, _ v2: Vector) -> Vector {
        return Vector(v1.x - v2.x, v1.y - v2.y, v1.z != nil ? (v1.z! - v2.z!) : nil)
    }
    
    public static func mult(_ v: Vector, _ n: Double) -> Vector {
        return Vector(v.x * n, v.y * n, v.z != nil ? (v.z! * n) : nil)
    }
    
    public static func div(_ v: Vector, _ n: Double) -> Vector {
        return Vector(v.x / n, v.y / n, v.z != nil ? (v.z! / n) : nil)
    }
    
    public static func dist(_ v1: Vector, _ v2: Vector) -> Double {
        return sqrt(pow(v2.x - v1.x, 2) + pow(v2.y - v1.y, 2) + (v1.z != nil ? pow(v2.z! - v1.z!, 2) : 0))
    }
    
    public static func dot(_ v1: Vector, _ v2: Vector) -> Double {
        return v1.x * v2.x + v2.y * v2.y + (v1.z ?? 0) * (v2.z ?? 0)//(v1.z != nil ? (v1.z! * v2.z!) : 0)
    }
    
    public static func cross(_ v1: Vector, _ v2: Vector) -> Vector {
        let x = v1.y * (v2.z ?? 0) - (v1.z ?? 0) * v2.y
        let y = (v1.z ?? 0) * v2.x - v1.x * (v2.z ?? 0)
        let z = v1.x * v2.y - v1.y * v2.x
        
        return Vector(x, y, z)
    }
    
}

// MARK: - Vector Math Functions
extension Vector {
    public func add(_ v: Vector) {
        let result = Vector.add(self, v)
        self.set(result)
    }
    
    public func sub(_ v: Vector) {
        let result = Vector.sub(self, v)
        self.set(result)
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
        return x * x + y * y + (z != nil ? z! * z! : 0)
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
//        var angle
        var angle = acos(min(1, max(-1, dotmagmag)))
        angle = angle * sign(self.cross(v).z ?? 1)
        
        return angle
        
//        if (this.p5) {
//            angle = this.p5._fromRadians(angle)
//        }
//        return angle;
    }
    
    func sign(_ num: Double) -> Double {
        return num >= 0 ? 1 : -1
    }
    
    public func heading() -> Radians {
        return atan2(self.y, self.x)
    }
}

