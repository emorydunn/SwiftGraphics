//
//  CGColor.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public struct Color: Equatable {
    
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
    
    /// Instantiate a new Color
    ///
    /// /// This method expects color values between `0` and `1`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red.clamped(to: 0...1)
        self.green = green.clamped(to: 0...1)
        self.blue = blue.clamped(to: 0...1)
        self.alpha = alpha.clamped(to: 0...1)
    }
    
    /// Instantiate a new Color
    ///
    /// This method expects color values between `0` and `255`
    ///
    /// - Parameters:
    ///   - r: Red value
    ///   - g: Green value
    ///   - b: Blue value
    ///   - a: Alpha value
    public init(_ r: Int, _ g: Int, _ b: Int, _ a: Float) {
        self.init(
            red: Float(r) / 255,
            green: Float(g) / 255,
            blue: Float(b) / 255,
            alpha: a
        )
    }
    
    public init(grey: Float, _ a: Float) {
        self.init(red: grey, green: grey, blue: grey, alpha: a)
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
        
        return "rgba(\(r),\(g),\(b),\(alpha))"
    }
    
    public static var black : Color { Color(red : 0, green : 0, blue : 0, alpha : 1) }
    public static var white : Color { Color(red : 1, green : 1, blue : 1, alpha : 1) }
    public static var clear : Color { Color(red : 0, green : 0, blue : 0, alpha : 0) }
    
    public static var red   : Color { Color(red : 1, green : 0, blue : 0, alpha : 1) }
    public static var green : Color { Color(red : 0, green : 1, blue : 0, alpha : 1) }
    public static var blue  : Color { Color(red : 0, green : 0, blue : 1, alpha : 1) }
    
}
