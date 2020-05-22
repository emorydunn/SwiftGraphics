//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public class Color: Equatable {
    let red: Float
    let green: Float
    let blue: Float
    let alpha: Float
    
    public init(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
    }
    
    public init(_ r: Int, _ g: Int, _ b: Int, _ a: Float) {
        self.red = Float(r) / 255
        self.green = Float(g) / 255
        self.blue = Float(b) / 255
        self.alpha = a
    }
    
    public init(grey: Float, _ a: Float) {
        self.red = grey
        self.green = grey
        self.blue = grey
        self.alpha = a
    }
    
    // Convert to a hex string
    // From: https://stackoverflow.com/a/26341062
    public func toHex() -> String {
        
        let r = lroundf(red * 255)
        let g = lroundf(green * 255)
        let b = lroundf(blue * 255)

        let hexString = String.init(format: "#%02lX%02lX%02lX", r, g, b)
        return hexString
    }
    
    public func toCGColor() -> CGColor {
        return CGColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
    
    public func toRGBA() -> String {
        let r = lroundf(red * 255)
        let g = lroundf(green * 255)
        let b = lroundf(blue * 255)
        
        return "rgba(\(r), \(g), \(b), \(alpha))"
    }
    
    public static var black: Color { Color(0, 0, 0, 1) }
    public static var white: Color { Color(1, 1, 1, 1) }
    public static var clear: Color { Color(0, 0, 0, 0) }
}
