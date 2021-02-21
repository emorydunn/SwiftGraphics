//
//  Perlin.swift
//  SwiftGraphics
//
//  Created by Emory Dunn on 7/25/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation


/// Generate Perlin noise. 
///
/// Implemented from p5.js
public class PerlinGenerator {
    
    /// A shared generator
    public static let shared = PerlinGenerator()
    
    let yWrapB = 4
    lazy var yWrap = 1 << yWrapB
    let zWrapB = 8
    lazy var zWrap = 1 << zWrapB
    let size = 4095
    
    /// The number of noise samples to blend together
    public var octives = 2
    
    /// The amount each octave loses influence
    var ampFalloff = 0.5
    
    /// The noise array
    var perlin = [Double]()
    
    /// Instantiate a new generator
    public init() {
        self.perlin = (0..<(size + 1)).map { _ in Double.random(in: 0...1) }
    }
    
    func scaledCosine(_ num: Double) -> Double {
        return 0.5 * (1 - cos(num * Double.pi))
    }
    
    /// Calculate the Perlin noise values for the specified coordinates
    /// - Parameter vector: Position for the noice value
    public func noise(_ vector: Vector) -> Double {
        return noise(vector.x, vector.y, vector.z)
    }
    
    
    /// Calculate the Perlin noise values for the specified coordinates
    /// - Parameters:
    ///   - x: `x` coordinate
    ///   - y: `y` coordinate
    ///   - z: `z` coordinate
    public func noise(_ x: Double, _ y: Double = 0, _ z: Double = 0) -> Double {
        
        // Create mutable copies
        var x = x
        var y = y
        var z = z
        
        // Ensure values are positive
        x.negate(ifLessThan: 0)
        y.negate(ifLessThan: 0)
        z.negate(ifLessThan: 0)
        
        var xi = floor(x)
        var yi = floor(y)
        var zi = floor(z)
        
        var xf = x - xi
        var yf = y - yi
        var zf = z - zi
        
        var r: Double = 0
        var ampl = 0.5
        
        
        (0..<octives).forEach { _ in
            var of: Int = Int(xi) + (Int(yi) << yWrapB) + (Int(zi) << zWrapB)
            
            let rxf = scaledCosine(xf)
            let ryf = scaledCosine(yf)
            
            var n1 = perlin[of & size]
            n1 += rxf * (perlin[(of + 1) & size] - n1)
            var n2 = perlin[(of + yWrap) & size]
            n2 += rxf * (perlin[(of + yWrap + 1) & size] - n2)
            n1 += ryf * (n2 - n1)
            
            of += zWrap
            n2 = perlin[of & size]
            n2 += rxf * (perlin[(of + 1) & size] - n2)
            var n3 = perlin[(of + yWrap) & size]
            n3 += rxf * (perlin[(of + yWrap + 1) & size] - n3)
            n2 += ryf * (n3 - n2)
            
            n1 += scaledCosine(zf) * (n2 - n1)
            
            
            r += n1 * ampl
            ampl *= ampFalloff
            
            xi = Double(Int(xi) << 1)
            xf += 2
            
            yi = Double(Int(yi) << 1)
            yf *= 2
            
            zi = Double(Int(zi) << 1)
            zf *= 2
            
            if xf >= 1 {
                xi += 1
                xf -= 1
            }
            if yf >= 1 {
                yi += 1
                yf -= 1
            }
            if zf >= 1 {
                zi += 1
                zf -= 1
            }
            
        }
        
        return r
        
    }
}
